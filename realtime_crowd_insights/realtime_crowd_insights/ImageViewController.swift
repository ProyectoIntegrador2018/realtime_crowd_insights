//
//  ImageViewController.swift
//  realtime_crowd_insights
//
//  Created by Lorraine Bichara Assad on 9/27/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//
// Source: https://stackoverflow.com/questions/56515871/how-to-open-the-imagepicker-in-swiftui

import UIKit
import AVFoundation
import SwiftUI

var globalImage:UIImage? = nil

struct ImageViewController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imageSourceType: String?

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageViewController>) {
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageViewController>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if(imageSourceType == "camera")
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        }
        else
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {

        var parent: ImageViewController

        init(_ parent: ImageViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[.originalImage] as! UIImage
            parent.image = imagePicked
            picker.dismiss(animated: true, completion: nil)
            globalImage = imagePicked
            if globalImage != nil
            {
                // image has been set
                ContentManager.shared.load {}
            }
            else
            {
                print("image has not been set yet")
            }
        }
    }
}
