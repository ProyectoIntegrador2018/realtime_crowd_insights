//
//  ContentManager.swift
//  realtime_crowd_insights
//
//  Created by Miguel Bazán on 10/10/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import Foundation
import UIKit

class Person: NSObject {
    fileprivate(set) var faceId: String!
    fileprivate(set) var avatar: UIImage!
}

class Photo: NSObject {
    var faceIds: [String]!
    var image: UIImage!
}

class ContentManager: NSObject {
    
    static let shared = ContentManager()
    
    private(set) var persons: [Person] = []
    private(set) var photos: [Photo] = []
    
    lazy var allPhotosFaceIds: [String] = {
        var allFaceIds: [String] = []
        for photo in photos {
            allFaceIds.append(contentsOf: photo.faceIds)
        }
        return allFaceIds
    }()
    
    func load(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            let (photoData, photoImage) = self.loadImageDetectFace()
            
            let faceIds = FaceRecognition.shared.DetectFaceIds(imageData: photoData)
            if !faceIds.isEmpty {
                let photo = Photo()
                photo.faceIds = faceIds
                photo.image = photoImage
                self.photos.append(photo)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func loadImageDetectFace() -> (Data, UIImage) {
        let data = globalImage?.jpegData(compressionQuality: 0.5)
        let image = UIImage.init(data: data!, scale: UIScreen.main.scale)!

        return (data!, image)
    }
    
    func photos(withFaceIds faceIds: [String]) -> [Photo] {
        var filteredPhotos: [Photo] = []
        
        let faceIdsSet = Set(faceIds)
        for photo in photos {
            let hasFaceIds = Set(photo.faceIds).intersection(faceIdsSet).isEmpty == false
            if hasFaceIds {
                filteredPhotos.append(photo)
            }
        }
        return filteredPhotos
    }
}
