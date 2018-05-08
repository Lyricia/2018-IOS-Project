//
//  ViewController.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 4. 30..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inputBusname : String?
    var inputSubwayname : String?
    
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
            if let detailtableview = segue.destination as? DetailDataTableViewController{
                detailtableview.input = inputBusname!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

