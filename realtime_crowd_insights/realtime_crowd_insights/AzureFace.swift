//
//  AzureFace.swift
//  realtime_crowd_insights
//
//  Created by Miguel Bazán on 9/25/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import Foundation
import UIKit

let APIKey = "<bfdf49183ece47dbb44f5595152b6390>"
let Region = "westcentralus"
let FindSimilarsUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/findsimilars"
let DetectUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true"

class FaceRecognition : NSObject {
    
    static let shared = FaceRecognition()
    
    func DetectFaceIds(imageData: Data) -> [String]{
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/octet-stream"
        headers["Ocp-Apim-Subscription-key"] = APIKey
        
        let response = self.makePOSTRequest(url: DetectUrl, postData: imageData, headers: headers)
        let faceIds = extractFaceIds(fromResponse: response)
        
        return faceIds
    }
    
    func findSimilars(faceId: String, faceIds: [String], completion: @escaping ([String]) -> Void) {
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Ocp-Apim-Subscription-Key"] = APIKey
        
        let params: [String: Any] = [
            "faceId": faceId,
            "faceIds": faceIds,
            "mode": "matchFace"
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: params)
        
        DispatchQueue.global(qos: .background).async {
            let response = self.makePOSTRequest(url: FindSimilarsUrl, postData: data, headers: headers)
            let faceIds = self.extractFaceIds(fromResponse: response, minConfidence: 0.4)
            
            DispatchQueue.main.async {
                completion(faceIds)
            }
        }
    }
    
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [AnyObject] {
        var object: [AnyObject] = []
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
//        Semaforo para hacer el request sincrono
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject], json != nil {
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
    
    private func extractFaceIds(fromResponse response: [AnyObject], minConfidence: Float? = nil) -> [String] {
        var faceIds: [String] = []
        for faceInfo in response {
            if let faceId = faceInfo["faceId"] as? String  {
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
