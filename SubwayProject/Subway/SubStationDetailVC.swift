//
//  SubStationDetailVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 7..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit
import MapKit

class SubStationDetailVC: UIViewController, XMLParserDelegate{

    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var MapView: MKMapView!
    
    var StationData : [AnyHashable : Any] = [:]
    
    var url : String?
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var XPOINT_WGS = NSMutableString()
    var YPOINT_WGS = NSMutableString()
    
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem.title = StationData["station_nm"] as? String
        if (code == "") {
            code = StationData["fr_code"] as! String
        }
        url = "http://openapi.seoul.go.kr:8088/774d47416663686f3634416867695a/xml/SearchLocationOfSTNByFRCodeService/1/5/" + code
        
        beginParsing()
    }

    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        
        let lat = (XPOINT_WGS as NSString).doubleValue
        let lon = (YPOINT_WGS as NSString).doubleValue
        let pos = CLLocation(latitude: lat, longitude: lon)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pos.coordinate, 500, 500)
        let sourcePlacemark = MKPlacemark(coordinate: pos.coordinate, addressDictionary: nil)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = StationData["station_nm"] as? String
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        self.MapView.showAnnotations([sourceAnnotation], animated: true)
        
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchBusStationByPos"{
            if let TVC = segue.destination as? SearchBusStationByPosVC{
                TVC.lat = (XPOINT_WGS as NSString).doubleValue
                TVC.lon = (YPOINT_WGS as NSString).doubleValue
                TVC.SubStationNm = StationData["station_nm"] as! String
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributeDict: [String:String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            XPOINT_WGS = NSMutableString()
            XPOINT_WGS = ""
            YPOINT_WGS = NSMutableString()
            YPOINT_WGS = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "XPOINT_WGS"){
            XPOINT_WGS.append(string)
        }
        if element.isEqual(to: "YPOINT_WGS"){
            YPOINT_WGS.append(string)
        }

    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "row"){
            if !XPOINT_WGS.isEqual(nil){
                elements.setObject(XPOINT_WGS, forKey: "XPOINT_WGS" as NSCopying)
            }
            if !YPOINT_WGS.isEqual(nil){
                elements.setObject(YPOINT_WGS, forKey: "YPOINT_WGS" as NSCopying)
            }

            posts.add(elements)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
