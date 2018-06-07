//
//  RouteMapVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 4..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit
import MapKit
class RouteMapVC: UIViewController, XMLParserDelegate, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    var input = ""
    var url : String?
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var gpsX = NSMutableString()
    var gpsY = NSMutableString()
    var no = NSMutableString()
    
    var routeCoord : [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getRoutePath?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&busRouteId=" + input
        
        beginParsing()
        if (posts.count == 0){
            let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertControllerStyle.actionSheet)
            
            let informantAction: UIAlertAction = UIAlertAction(title: "결과가 없습니다.", style: UIAlertActionStyle.destructive, handler:{
                (action: UIAlertAction!) -> Void in
            })
    
            alert.addAction(informantAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        for i in 0..<posts.count{
            let lat = ((posts.object(at: i) as AnyObject).value(forKey: "gpsY") as! NSString).doubleValue
            let lon = ((posts.object(at: i) as AnyObject).value(forKey: "gpsX") as! NSString).doubleValue
            let pos = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            routeCoord.append(pos)
        }
        
        createPolyline(mapView: mapView)
        // Do any additional setup after loading the view.
    }
    
    func createPolyline(mapView: MKMapView) {
        let polyline = MKPolyline(coordinates: routeCoord, count: posts.count)
        mapView.add(polyline)

        let pos = CLLocation(latitude: self.routeCoord[0].latitude, longitude: self.routeCoord[0].longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pos.coordinate, 2000, 2000)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
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
            no = NSMutableString()
            no = ""
            gpsX = NSMutableString()
            gpsX = ""
            gpsY = NSMutableString()
            gpsY = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "no"){
            no.append(string)
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
            if !no.isEqual(nil){
                elements.setObject(no, forKey: "no" as NSCopying)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be
    }
}
