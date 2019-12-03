//
//  ResultsViewController.swift
//  realtime_crowd_insights_sb
//
//  Created by Lorraine Bichara Assad on 11/11/19.
//  Copyright © 2019 Lorraine Bichara Assad. All rights reserved.
//
//  Source: https://medium.com/@anitaa_1990/create-a-horizontal-paging-uiscrollview-with-uipagecontrol-swift-4-xcode-9-a3dddc845e92

import UIKit
import CoreData

class ResultsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var slides:[Slide] = [];
    
    override func viewWillAppear(_ animated: Bool)  {
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Slide] {
        slides = [] // to reset array of slides
        if(globalAmountOfPeople <= 0)
        {
            
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            
            slide.lbAlert.text = "Cannot connect to Azure. Please try again later."
            slide.lbAge.text = ""
            slide.lbDisgust.text = ""
            slide.lbAnger.text = ""
            slide.lbSadness.text = ""
            slide.lbHappiness.text = ""
            slide.lbNeutral.text = ""
            slide.lbContempt.text = ""
            slide.lbSurprise.text = ""
            slide.lbFear.text = ""
            slide.lbGender.text = ""
            
            slide.age.text = ""
            slide.disgust.text = ""
            slide.anger.text = ""
            slide.sadness.text = ""
            slide.happiness.text = ""
            slide.neutral.text = ""
            slide.contempt.text = ""
            slide.surprise.text = ""
            slide.fear.text = ""
            slide.gender.text = ""
            print("Cannot connect to Azure. Please try again later.")
            
            slides.append(slide)
        }
        else
        {
            for i in 0...globalAmountOfPeople-1
            {
                let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide

                let rWidth = Int(globalResponse[i]["rWidth"]!)!
                let rHeight = Int(globalResponse[i]["rHeight"]!)
                let rLeft = Int(globalResponse[i]["rLeft"]!)
                let rTop = Int(globalResponse[i]["rTop"]!)!

                let imgWithRectangle = drawRectangleOnImage(image: globalImage!, w: rWidth, h: rHeight!, l: rLeft!, t: rTop)

                slide.imageView.image = imgWithRectangle
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
                createData(response: globalResponse[i], image:globalImageData)
            }
            print(globalResponse)
            globalAmountOfPeople = 0
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

    func drawRectangleOnImage(image: UIImage, w: Int, h: Int, l: Int, t: Int) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)

        let rectangle = CGRect(x: l, y: t, width: w, height: h)

        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(8.0)
        context.setStrokeColor(UIColor.red.cgColor)
    
        UIRectFrame(rectangle)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // Function that creates a user entity and saves it using Core Data
    func createData(response: Dictionary<String, String>, image: Data){
        // print("Creating data")
        //Inside the AppDelegate we have the container we want to refer to
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        //Now we create a context from the container
        let context = appDelegate.persistentContainer.viewContext

        //Creating new entity for new records
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!

        // Get count of elements in core data
        var count = 0
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "isActive == true")
            count = try context.count(for: fetchRequest)
        } catch {
            print("Error")
        }

        //Adding new information
        let user = NSManagedObject(entity: entity, insertInto: context)
        user.setValue(Int(response["age"]!), forKey: "age")

        // Get predominating emotion
        var emotions = [String: String]()
        emotions["disgust"] = response["disgust"]
        emotions["anger"] = response["anger"]
        emotions["sadness"] = response["sadness"]
        emotions["happiness"] = response["happiness"]
        emotions["neutral"] = response["neutral"]
        emotions["contempt"] = response["contempt"]
        emotions["surprise"] = response["surprise"]
        emotions["fear"] = response["fear"]

        var maxEmotion = emotions["disgust"]
        var predominatingEmotion = ""
        for emotion in emotions
        {
            print(emotion.value)
            if emotion.value > maxEmotion!
            {
                maxEmotion = emotion.value
                predominatingEmotion = emotion.key
            }
        }

        user.setValue(predominatingEmotion, forKey: "emotion")
        user.setValue(response["faceId"], forKey: "faceId")
        user.setValue(response["gender"], forKey: "gender")
        user.setValue("Visitor " + String(count), forKey: "name")
        user.setValue(1, forKey: "visits")
         user.setValue(true, forKey: "isActive")
        user.setValue(NSDate(), forKey: "createdAt")
        user.setValue(image, forKey: "image")

        //Trying to save it inside Core Data
        do{
            try context.save()
        }catch{
            fatalError("Error while creating data - func createData() 'HistoryTableViewController'")
        }
    }
}
