//
//  StationDetailVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 19..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit
import MapKit

class StationDetailVC: UIViewController, XMLParserDelegate {
   
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var titleitem: UINavigationItem!
    @IBOutlet weak var BookmarkButton: UIBarButtonItem!
    @IBAction func AddBookmark(_ sender: Any) {
        if isBookmarked == true{
            Bookmark.Instance.removedata(name: titleitem.title!)
            isBookmarked = false
            BookmarkButton.tintColor = nil
        }
        else {
            let data = bookmarkdata(_type: "BusStation", _name: titleitem.title!, _code: input)
            Bookmark.Instance.savedata(data: data)
            BookmarkButton.tintColor = UIColor.red
            isBookmarked = true
        }
    }
    
    var input = ""
    var url : String?
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    var postsize = 0
    
    var stNm = NSMutableString()
    var rtNm = NSMutableString()
    var arrmsgSec1 = NSMutableString()
    var arrmsgSec2 = NSMutableString()
    var gpsX = NSMutableString()
    var gpsY = NSMutableString()
    
    var isBookmarked = false
    
    override func viewDidLoad() {
        url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&arsId=" + input

        super.viewDidLoad()
        beginParsing()
        
        for data in Bookmark.Instance.list {
            if data.name == titleitem.title! {
                isBookmarked = true
                BookmarkButton.tintColor = UIColor.red
            }
        }
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        
        let lat = (gpsY as NSString).doubleValue
        let lon = (gpsX as NSString).doubleValue
        let pos = CLLocation(latitude: lat, longitude: lon)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pos.coordinate, 500, 500)
        let sourcePlacemark = MKPlacemark(coordinate: pos.coordinate, addressDictionary: nil)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = String(stNm)
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        self.MapView.showAnnotations([sourceAnnotation], animated: true )
        
        MapView.setRegion(coordinateRegion, animated: true)
            
        TextView.text.append(String(stNm) + "\n\n")
        titleitem.title = String(stNm)
        
        for post in posts{
            let route = (post as AnyObject).value(forKey:"rtNm") as! NSString as String
            let arrivemsg1 = (post as AnyObject).value(forKey:"arrmsgSec1") as! NSString as String
            let arrivemsg2 = (post as AnyObject).value(forKey:"arrmsgSec2") as! NSString as String
            
            TextView.text.append(String(route) + "\n")
            TextView.text.append(String(arrivemsg1) + "\n")
            TextView.text.append(String(arrivemsg2) + "\n")
            TextView.text.append("\n")
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributeDict: [String:String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "itemList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            stNm = NSMutableString()
            stNm = ""
            rtNm = NSMutableString()
            rtNm = ""
            arrmsgSec1 = NSMutableString()
            arrmsgSec1 = ""
            arrmsgSec2 = NSMutableString()
            arrmsgSec2 = ""
            gpsX = NSMutableString()
            gpsX = ""
            gpsY = NSMutableString()
            gpsY = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "stNm"){
            stNm.append(string)
        }
        if element.isEqual(to: "rtNm"){
            rtNm.append(string)
        }
        if element.isEqual(to: "arrmsgSec1"){
            arrmsgSec1.append(string)
        }
        if element.isEqual(to: "arrmsgSec2"){
            arrmsgSec2.append(string)
        }
        if element.isEqual(to: "gpsX"){
            gpsX.append(string)
        }
        if element.isEqual(to: "gpsY"){
            gpsY.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "itemList"){
            if !stNm.isEqual(nil){
                elements.setObject(stNm, forKey: "stNm" as NSCopying)
            }
            if !rtNm.isEqual(nil){
                elements.setObject(rtNm, forKey: "rtNm" as NSCopying)
            }
            if !arrmsgSec1.isEqual(nil){
                elements.setObject(arrmsgSec1, forKey: "arrmsgSec1" as NSCopying)
            }
            if !arrmsgSec2.isEqual(nil){
                elements.setObject(arrmsgSec2, forKey: "arrmsgSec2" as NSCopying)
            }
            if !gpsX.isEqual(nil){
                elements.setObject(gpsX, forKey: "gpsX" as NSCopying)
            }
            if !gpsY.isEqual(nil){
                elements.setObject(gpsY, forKey: "gpsY" as NSCopying)
            }
            posts.add(elements)
            postsize += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
