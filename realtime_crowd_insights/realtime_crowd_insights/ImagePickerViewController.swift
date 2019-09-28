//
//  ImagePickerViewController.swift
//  realtime_crowd_insights
//
//  Created by Lorraine Bichara Assad on 9/27/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//
// Source: https://stackoverflow.com/questions/56515871/how-to-open-the-imagepicker-in-swiftui

import UIKit
import AVFoundation
import SwiftUI

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {

        var parent: ImagePickerViewController

        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[.originalImage] as! UIImage
            parent.image = imagePicked
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
