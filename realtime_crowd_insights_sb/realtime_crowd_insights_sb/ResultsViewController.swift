//
//  ResultsViewController.swift
//  realtime_crowd_insights_sb
//
//  Created by Lorraine Bichara Assad on 11/11/19.
//  Copyright © 2019 Lorraine Bichara Assad. All rights reserved.
//
//  Source: https://medium.com/@anitaa_1990/create-a-horizontal-paging-uiscrollview-with-uipagecontrol-swift-4-xcode-9-a3dddc845e92

import UIKit

class ResultsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Slide] {
        slides = [] // to reset array of slides
        for i in 0...globalAmountOfPeople-1
        {
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.imageView.image = globalImage
            slide.lbAge.text = globalResponse[i]["age"]
            slide.lbDisgust.text = globalResponse[i]["disgust"]
            slide.lbAnger.text = globalResponse[i]["anger"]
            slide.lbSadness.text = globalResponse[i]["sadness"]
            slide.lbHappiness.text = globalResponse[i]["happiness"]
            slide.lbNeutral.text = globalResponse[i]["neutral"]
            slide.lbContempt.text = globalResponse[i]["contempt"]
            slide.lbSurprise.text = globalResponse[i]["surprise"]
            slide.lbFear.text = globalResponse[i]["fear"]
            slide.lbGender.text = globalResponse[i]["gender"]

            slides.append(slide)
        }
        
        return slides
    }
    
    func setupSlideScrollView(slides : [Slide]) {
           scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
           scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
           scrollView.isPagingEnabled = true
           
           for i in 0 ..< slides.count {
               slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
               scrollView.addSubview(slides[i])
           }
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
