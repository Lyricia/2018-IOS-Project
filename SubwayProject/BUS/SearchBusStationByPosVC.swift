//
//  SearchBusStationByPosTVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 8..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit
import MapKit

class SearchBusStationByPosVC: UIViewController, XMLParserDelegate, MKMapViewDelegate {
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    var lat : Double = 0
    var lon : Double = 0
    
    var SubStationNm = ""
    
    var url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByPos?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&radius=300"
    //&tmX=127.09468099999999&tmY=37.535094999999998
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var stationNm = NSMutableString()
    var arsId = NSMutableString()
    var stationId = NSMutableString()
    var gpsX = NSMutableString()
    var gpsY = NSMutableString()
    
    var selectedStationNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url += "&tmX=" + String(lon) + "&tmY=" + String(lat)
        
        beginParsing()
        MapView.delegate = self
        
        for i in 0..<posts.count{
            let _lat = ((posts.object(at: i) as AnyObject).value(forKey: "gpsY") as! NSString).doubleValue
            let _lon = ((posts.object(at: i) as AnyObject).value(forKey: "gpsX") as! NSString).doubleValue
            
            let annotation = MKPointAnnotation()
            annotation.title = (posts.object(at: i) as AnyObject).value(forKey: "stationNm") as! NSString as String
            annotation.subtitle = (posts.object(at: i) as AnyObject).value(forKey: "arsId") as! NSString as String
            annotation.coordinate = CLLocationCoordinate2D(latitude: _lat, longitude: _lon)
            MapView.addAnnotation(annotation)
        }
        
        
        let pos = CLLocation(latitude: lat, longitude: lon)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pos.coordinate, 500, 500)
        let sourcePlacemark = MKPlacemark(coordinate: pos.coordinate, addressDictionary: nil)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = SubStationNm
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        self.MapView.showAnnotations([sourceAnnotation], animated: true)
        
        MapView.setRegion(coordinateRegion, animated: true)
        TitleBar.title = SubStationNm
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedStationNo = ((view.annotation?.subtitle)!)!
            performSegue(withIdentifier: "SearchBusStationDetail", sender: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .contactAdd)
            rightButton.tag = annotation.hash
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        }
        else {
            return nil
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchBusStationDetail"{
            if let detailtableview = segue.destination as? StationDetailVC{
                detailtableview.input = selectedStationNo
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributeDict: [String:String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "itemList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            stationNm = NSMutableString()
            stationNm = ""
            arsId = NSMutableString()
            arsId = ""
            stationId = NSMutableString()
            stationId = ""
            gpsX = NSMutableString()
            gpsX = ""
            gpsY = NSMutableString()
            gpsY = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "stationNm"){
            stationNm.append(string)
        }
        if element.isEqual(to: "arsId"){
            arsId.append(string)
        }
        if element.isEqual(to: "stationId"){
            stationId.append(string)
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
            if !stationNm.isEqual(nil){
                elements.setObject(stationNm, forKey: "stationNm" as NSCopying)
            }
            if !arsId.isEqual(nil){
                elements.setObject(arsId, forKey: "arsId" as NSCopying)
            }
            if !stationId.isEqual(nil){
                elements.setObject(stationId, forKey: "stationId" as NSCopying)
            }
            if !gpsX.isEqual(nil){
                elements.setObject(gpsX, forKey: "gpsX" as NSCopying)
            }
            if !gpsY.isEqual(nil){
                elements.setObject(gpsY, forKey: "gpsY" as NSCopying)
            }
            posts.add(elements)
        }
    }
}
