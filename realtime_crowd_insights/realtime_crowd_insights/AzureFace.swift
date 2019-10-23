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

class FaceRecognition : NSObject {
    
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
//
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
        
        //print(object)
        return object
    }
    
    private func printFaceInfo(fromResponse response: JSON, minConfidence: Float? = nil) {
        for i in 0...response.count-1
        {
            print("faceId: " + response[i]["faceId"].stringValue)
            print("Age: " + response[i]["faceAttributes"]["age"].stringValue)
            print("Emotion Disgust: " + response[i]["faceAttributes"]["emotion"]["disgust"].stringValue)
            print("Emotion Anger: " + response[i]["faceAttributes"]["emotion"]["anger"].stringValue)
            print("Emotion Sadness: " + response[i]["faceAttributes"]["emotion"]["sadness"].stringValue)
            print("Emotion Happiness: " + response[i]["faceAttributes"]["emotion"]["happiness"].stringValue)
            print("Emotion Neutral: " + response[i]["faceAttributes"]["emotion"]["neutral"].stringValue)
            print("Emotion Contempt: " + response[i]["faceAttributes"]["emotion"]["contempt"].stringValue)
            print("Emotion Surprise: " + response[i]["faceAttributes"]["emotion"]["surprise"].stringValue)
            print("Emotion Fear: " + response[i]["faceAttributes"]["emotion"]["fear"].stringValue)
            print("Gender: " + response[i]["faceAttributes"]["gender"].stringValue)
            print("--------------------------------------")
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
