//
//  AzureFace.swift
//  realtime_crowd_insights
//
//  Created by Miguel Bazán on 9/25/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreData

let APIKey = valueForAPIKey(named:"API_SECRET")
let Region = "eastusus"
let FindSimilarsUrl = "https://crowdinsights.cognitiveservices.azure.com/face/v1.0/findsimilars"
let DetectUrl = "https://crowdinsights.cognitiveservices.azure.com/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,emotion"
let addPersonUrl = "https://crowdinsights.cognitiveservices.azure.com/face/v1.0/persongroups/myList/persons"
var globalImage:UIImage? = nil
var globalResponse: [Dictionary<String, String>] = []
var globalAmountOfPeople = 0
var globalImageData = Data()

class FaceRecognition : NSObject {
    var globalImage:UIImage? = nil
    
    static let shared = FaceRecognition()
    
    func DetectFaceIds(imageData: Data) -> [String]{
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/octet-stream"
        headers["Ocp-Apim-Subscription-key"] = APIKey
        
        let response = self.makePOSTRequest(url: DetectUrl, postData: imageData, headers: headers)
        printFaceInfo(fromResponse: response, image: imageData)
        
        //let faceIds = extractFaceIds(fromResponse: response)
        let faceIds = [String]()
        return faceIds
    }
    
    // TODO findsimilars
    func findSimilars(faceId: String, faceIds: [String]) {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Ocp-Apim-Subscription-Key"] = APIKey

        let params: [String: Any] = [
            "faceId": faceId,
            "faceIds": faceIds,
        ]

        let data = try! JSONSerialization.data(withJSONObject: params)

        DispatchQueue.global(qos: .background).async {
            let responseSimilar = self.makePOSTRequest(url: FindSimilarsUrl, postData: data, headers: headers)
            if(responseSimilar.count > 0 ){
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

                for (_, id) in responseSimilar{
                    let context = appDelegate.persistentContainer.viewContext
                    let fetchtRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

                    fetchtRequest.predicate = NSPredicate(format: "faceId == %@", (id["faceId"].stringValue) as String)
                    do {
                        let userList = try context.fetch(fetchtRequest) as! [User]

                        if let userUpdate = userList.first {
                            print(userUpdate.faceId!)
                            userUpdate.setValue(false, forKey: "isActive")

                         }
                        try context.save()
                    }
                    catch {
                        print("error executing delete request: \(error)")
                    }
                }
                let context = appDelegate.persistentContainer.viewContext
                let fetchtRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                
                fetchtRequest.predicate = NSPredicate(format: "faceId == %@", faceId)
                do {
                    let userList = try context.fetch(fetchtRequest) as! [User]

                    if let userUpdate = userList.first {

                        userUpdate.visits = Int64(responseSimilar.count)
                         userUpdate.isActive = true
                     }
                     try context.save()
                }
                catch {
                    print("error executing fetch request: \(error)")
                }
            }
        }
        
    }
    
    func addPersonToAzureGroup(faceId: String){
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Ocp-Apim-Subscription-Key"] = APIKey

        let params: [String: Any] = [
            "personGroupId": 1,
            "personId": faceId,
        ]

        let data = try! JSONSerialization.data(withJSONObject: params)

        DispatchQueue.global(qos: .background).async {
            let responseAdd = self.makePOSTRequest(url: addPersonUrl + faceId + "/", postData: data, headers: headers)
        }
    }
    
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> JSON {
        var object:JSON = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Semaforo para hacer el request sincrono
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSON(data: data){
                object = json
            }
            else {
                print("ERROR response: \(String(data: data!, encoding: .utf8) ?? "")")
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return object
    }
    
    private func printFaceInfo(fromResponse response: JSON, image: Data, minConfidence: Float? = nil) {
        globalResponse = []
        globalAmountOfPeople = response.count
        
        var faceIdsInCoreData = [String]()

        //Inside the AppDelegate we have the container we want to refer to
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        //Now we create a context from the container
        let context = appDelegate.persistentContainer.viewContext

        //We prepare the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        do {
            let calendar = Calendar.current
            let users = try context.fetch(request)
            for user in users {
                if (calendar.isDateInToday((user as AnyObject).createdAt ?? (NSDate.distantPast as NSDate) as Date)){
                    faceIdsInCoreData.append((user as AnyObject).faceId!)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        print(globalAmountOfPeople)
        
        for i in 0...globalAmountOfPeople-1
        {
            let tempDict = [
                "faceId": response[i]["faceId"].stringValue,
                "age": response[i]["faceAttributes"]["age"].stringValue,
                "disgust": response[i]["faceAttributes"]["emotion"]["disgust"].stringValue,
                "anger": response[i]["faceAttributes"]["emotion"]["anger"].stringValue,
                "sadness": response[i]["faceAttributes"]["emotion"]["sadness"].stringValue,
                "happiness": response[i]["faceAttributes"]["emotion"]["happiness"].stringValue,
                "neutral": response[i]["faceAttributes"]["emotion"]["neutral"].stringValue,
                "contempt": response[i]["faceAttributes"]["emotion"]["contempt"].stringValue,
                "surprise": response[i]["faceAttributes"]["emotion"]["surprise"].stringValue,
                "fear": response[i]["faceAttributes"]["emotion"]["fear"].stringValue,
                "gender": response[i]["faceAttributes"]["gender"].stringValue,
                "rWidth": response[i]["faceRectangle"]["width"].stringValue,
                "rHeight": response[i]["faceRectangle"]["height"].stringValue,
                "rLeft": response[i]["faceRectangle"]["left"].stringValue,
                "rTop": response[i]["faceRectangle"]["top"].stringValue
            ]
            print(response)
            //Wait for current ID to be saved on db, so find similars can find a person again.
            let secondsToDelay = 30.0
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
               let findSimilarsss = FaceRecognition.shared.findSimilars(faceId:response[i]["faceId"].stringValue,faceIds:faceIdsInCoreData )
            }

            globalResponse.append(tempDict)
            globalImageData = image
        }
    }
    
    private func extractFaceIds(fromResponse response: [AnyObject], minConfidence: Float? = nil) -> [String]
    {
        var faceIds: [String] = []
        for faceInfo in response {
            if let faceId = faceInfo["faceId"] as? String {
                var canAddFace = true
                if minConfidence != nil {
                    let confidence = (faceInfo["confidence"] as! NSNumber).floatValue
                    canAddFace = confidence >= minConfidence!
                }
                if canAddFace { faceIds.append(faceId) }
            }
        }
        return faceIds
    }
}
