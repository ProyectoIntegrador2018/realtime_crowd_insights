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

let APIKey = valueForAPIKey(named:"API_SECRET")
let Region = "eastusus"
let FindSimilarsUrl = "https://crowdinsights.cognitiveservices.azure.com/face/v1.0/findsimilars"
let DetectUrl = "https://crowdinsights.cognitiveservices.azure.com/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,emotion"
var globalImage:UIImage? = nil
var globalResponse: [Dictionary<String, String>] = []
var globalAmountOfPeople = 0

class FaceRecognition : NSObject {
    var globalImage:UIImage? = nil
    
    static let shared = FaceRecognition()
    
    func DetectFaceIds(imageData: Data) -> [String]{
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/octet-stream"
        headers["Ocp-Apim-Subscription-key"] = APIKey
        
        let response = self.makePOSTRequest(url: DetectUrl, postData: imageData, headers: headers)
        printFaceInfo(fromResponse: response)
        
        //let faceIds = extractFaceIds(fromResponse: response)
        let faceIds = [String]()
        return faceIds
    }
    
    // TODO findsimilars
//    func findSimilars(faceId: String, faceIds: [String], completion: @escaping ([String]) -> Void) {
//        var headers: [String: String] = [:]
//        headers["Content-Type"] = "application/json"
//        headers["Ocp-Apim-Subscription-Key"] = APIKey
//
//        let params: [String: Any] = [
//            "faceId": faceId,
//            "faceIds": faceIds,
//            "mode": "matchFace"
//        ]
//
//        let data = try! JSONSerialization.data(withJSONObject: params)
//
//        DispatchQueue.global(qos: .background).async {
//            let response = self.makePOSTRequest(url: FindSimilarsUrl, postData: data, headers: headers)
//            let faceIds = self.extractFaceIds(fromResponse: response, minConfidence: 0.4)
//
//            DispatchQueue.main.async {
//                completion(faceIds)
//            }
//        }
//    }
    
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
    
    private func printFaceInfo(fromResponse response: JSON, minConfidence: Float? = nil) {
        globalResponse = []
        globalAmountOfPeople = response.count
        
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
            
            globalResponse.append(tempDict)
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
