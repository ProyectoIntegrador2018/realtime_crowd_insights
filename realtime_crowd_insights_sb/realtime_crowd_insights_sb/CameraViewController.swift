//
//  CameraViewController.swift
//  realtime_crowd_insights_sb
//
//  Created by Lorraine Bichara Assad on 11/11/19.
//  Copyright © 2019 Lorraine Bichara Assad. All rights reserved.
//  Source: https://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
            
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func useImage(_ sender: UIButton) {
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
