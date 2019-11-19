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
    var race = String()
    var visit = String()
    var age = String()
    var slide = History()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbEmotion: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbFaceID: UILabel!
    @IBOutlet weak var lbVisits: UILabel!
    @IBOutlet weak var lbRace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        printData()
        lbName.text = name
        lbEmotion.text = emotion
        lbFaceID.text = faceId
        lbGender.text = gender
        lbRace.text = race
        lbVisits.text = visit
        lbAge.text = age
//        slide = createSlide()
//        setupSlideScrollView(slides: slide)
    }
    
    func createSlide() -> History{
        let slide: History = Bundle.main.loadNibNamed("HistoryResult", owner: self, options: nil)?.first as! History
        
        slide.lbName.text = name
        slide.lbEmotion.text = emotion
        slide.lbFaceID.text = faceId
        slide.lbGender.text = gender
        slide.lbRace.text = race
        slide.lbVisit.text = visit
        slide.lbAge.text = age
        
        return slide
    }
    
    func printData(){
        print("name: " + name)
        print("age: " + age)
        print("emotion: " + emotion)
        print("faceID: " + faceId)
        print("gender: " + gender)
        print("visits: " + visit)
    }
    
//    func setupSlideScrollView(slides : History) {
//           scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//           scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
//           scrollView.isPagingEnabled = true
//           
//           slide.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
//           scrollView.addSubview(slide)
//           
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
