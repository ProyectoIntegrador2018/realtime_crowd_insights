//
//  HistoryViewController.swift
//  realtime_crowd_insights_sb
//
//  Created by Mickey Rocha on 11/14/19.
//  Copyright © 2019 Lorraine Bichara Assad. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController{

    var name =  String()
    var emotion = String()
    var faceId = String()
    var gender = String()
    var visit = String()
    var age = String()
    var image = UIImage()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbEmotion: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbFaceID: UILabel!
    @IBOutlet weak var lbVisits: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        lbName.text = name
        lbEmotion.text = emotion
        lbFaceID.text = faceId
        lbGender.text = gender
        lbVisits.text = visit
        lbAge.text = age
        imageView.image = image
    }
}
