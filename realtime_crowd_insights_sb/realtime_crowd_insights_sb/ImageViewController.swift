//
//  ImageViewController.swift
//  realtime_crowd_insights_sb
//
//  Created by Lorraine Bichara Assad on 11/11/19.
//  Copyright © 2019 Lorraine Bichara Assad. All rights reserved.
//  Source: https://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/

//  View controller that handles the image picker from the camera and from the photo library.

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var imageView: UIImageView!
   
    @IBAction func loadImageFromPhotoLib(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        loadImage()
    }
    
    @IBAction func loadImageFromCamera(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        loadImage()
    }

    func loadImage() {
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            globalImage = pickedImage
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
     
        dismiss(animated: true, completion: nil)
    }
}
