//
//  ViewController.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 4. 30..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var inputBusname : String?
    var inputSubwayname : String?
    
    @IBOutlet weak var FrontView: UIView!
    @IBOutlet weak var BehindView: UIView!
    var flipped = false
    @IBAction func flipView(_ sender: Any) {
//        flipped = !flipped
//        let fromview = flipped ? FrontView : BehindView
//        let toview = flipped ? BehindView : FrontView
//        UIView.transition(from: fromview!, to: toview!, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
        print("tapped")
    }

    @IBAction func SwipeView(_ sender: Any) {
        flipped = !flipped
        let fromview = flipped ? FrontView : BehindView
        let toview = flipped ? BehindView : FrontView

        UIView.transition(from: fromview!, to: toview!, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    @IBAction func SwipeView2(_ sender: Any) {
        flipped = !flipped
        let fromview = flipped ? FrontView : BehindView
        let toview = flipped ? BehindView : FrontView
        
        UIView.transition(from: fromview!, to: toview!, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }

    @IBOutlet weak var BusName: UITextField!
    @IBOutlet weak var ButtonSearch: UIButton!
    @IBAction func ActionSearch(_ sender: Any) {
        inputBusname = BusName.text
    }
    
    @IBOutlet weak var SubwayName: UITextField!
    @IBAction func SearchSubway(_ sender: Any) {
        inputSubwayname = SubwayName.text
    }
    
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchBus"{
            if let detailtableview = segue.destination as? DetailDataTableViewController{
                detailtableview.input = inputBusname!
            }
        }
        if segue.identifier == "SearchSubway"{
            if let detailtableview = segue.destination as? SubwayDetailDataTBC{
                detailtableview.input = inputSubwayname!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(FrontView.frame.size)
        UIImage(named: "SubBG.jpg")?.draw(in: FrontView.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        FrontView.backgroundColor = UIColor(patternImage: image)
        
        UIGraphicsBeginImageContext(BehindView.frame.size)
        UIImage(named: "BusBG.jpg")?.draw(in: BehindView.bounds)
        let image2: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        BehindView.backgroundColor = UIColor(patternImage: image2)
        
        if (dataloaded == false){
            loadData()
            CollapseAllData()
            dataloaded = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

