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
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var BookmarkButton: UIBarButtonItem!
    @IBAction func AddBookmark(_ sender: Any) {
        if isBookmarked == true{
            Bookmark.Instance.removedata(name: StationData["station_nm"] as! String)
            isBookmarked = false
            BookmarkButton.tintColor = nil
            SoundManager.Instance.PlaySound(type: 0)
        }
        else {
            let data = bookmarkdata(_type: "SubStation", _name: StationData["station_nm"] as! String, _code: StationData["fr_code"] as! String)
            Bookmark.Instance.savedata(data: data)
            BookmarkButton.tintColor = UIColor.red
            isBookmarked = true
            SoundManager.Instance.PlaySound(type: 1)
        }
    }
    
    var StationData : [AnyHashable : Any] = [:]
    
    var url : String?
    var strutf8 : String?
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var XPOINT_WGS = NSMutableString()
    var YPOINT_WGS = NSMutableString()
    
    var lat : Double?
    var lon : Double?
    
    var recptnDt = NSMutableString()
    var arvlMsg2 = NSMutableString()
    var arvlMsg3 = NSMutableString()
    var trainLineNm = NSMutableString()
    var subwayId = NSMutableString()
    
    var total = NSMutableString()
    
    var code = ""
    var isBookmarked = false
    var isPosParsed = false
    
    var counter = 0
    
    let lineidmatcher = [
        "1001" : "1호선",
        "1002" : "2호선",
        "1003" : "3호선",
        "1004" : "4호선",
        "1005" : "5호선",
        "1006" : "6호선",
        "1007" : "7호선",
        "1008" : "8호선",
        "1009" : "9호선",
        "1063" : "경의중앙선",
        "1067" : "경춘선",
        "1075" : "분당선",
        "1071" : "수인선",
        "1077" : "신분당선",
        "1065" : "공항철도"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        naviItem.title = StationData["station_nm"] as? String
        code = StationData["fr_code"] as! String
        strutf8 = (StationData["station_nm"] as? String)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        for data in Bookmark.Instance.list {
            if data.name == StationData["station_nm"] as? String {
                isBookmarked = true
                BookmarkButton.tintColor = UIColor.red
            }
        }
        
        url = "http://openapi.seoul.go.kr:8088/774d47416663686f3634416867695a/xml/SearchLocationOfSTNByFRCodeService/1/5/" + code
        beginParsing()
        setMapPosition()
        isPosParsed = true
        
        posts = []
        url = "http://swopenapi.seoul.go.kr/api/subway/744255744663686f3130305667654b73/xml/realtimeStationArrival/1/100/" + strutf8!
        beginParsing()
        
        
        for post in posts{
            let subwaylineid = lineidmatcher[(post as AnyObject).value(forKey:"subwayId") as! NSString as String]
            let trainLineNm = (post as AnyObject).value(forKey:"trainLineNm") as! NSString as String
            let arvlMsg2 = (post as AnyObject).value(forKey:"arvlMsg2") as! NSString as String
            let arvlMsg3 = (post as AnyObject).value(forKey:"arvlMsg3") as! NSString as String
            
            TextView.text.append(subwaylineid! + "   " + String(trainLineNm) + "\n")
            TextView.text.append("현재 위치 : " + String(arvlMsg3) + "\n")
            TextView.text.append("도착 시간 : " + String(arvlMsg2) + "\n")
            
            TextView.text.append("\n")
        }
        
    }
    
    func setMapPosition(){
        let pos = CLLocation(latitude: lat!, longitude: lon!)
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

    func beginParsing(){
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchBusStationByPos"{
            if let TVC = segue.destination as? SearchBusStationByPosVC{
                TVC.lat = lat!
                TVC.lon = lon!
                TVC.SubStationNm = StationData["station_nm"] as! String
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributeDict: [String:String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "RESULT")
        {
            total = NSMutableString()
            total = ""
        }
        if(elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            XPOINT_WGS = NSMutableString()
            XPOINT_WGS = ""
            YPOINT_WGS = NSMutableString()
            YPOINT_WGS = ""
            recptnDt = NSMutableString()
            recptnDt = ""
            arvlMsg2 = NSMutableString()
            arvlMsg2 = ""
            arvlMsg3 = NSMutableString()
            arvlMsg3 = ""
            trainLineNm = NSMutableString()
            trainLineNm = ""
            subwayId = NSMutableString()
            subwayId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "total"){
            total.append(string)
        }
        if element.isEqual(to: "XPOINT_WGS"){
            XPOINT_WGS.append(string)
        }
        if element.isEqual(to: "YPOINT_WGS"){
            YPOINT_WGS.append(string)
        }
        if element.isEqual(to: "recptnDt"){
            recptnDt.append(string)
        }
        if element.isEqual(to: "arvlMsg2"){
            arvlMsg2.append(string)
        }
        if element.isEqual(to: "arvlMsg3"){
            arvlMsg3.append(string)
        }
        if element.isEqual(to: "trainLineNm"){
            trainLineNm.append(string)
        }
        if element.isEqual(to: "subwayId"){
            subwayId.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "row"){
            if (isPosParsed == false){
                if !XPOINT_WGS.isEqual(nil){
                    elements.setObject(XPOINT_WGS, forKey: "XPOINT_WGS" as NSCopying)
                    lat = (XPOINT_WGS as NSString).doubleValue
                }
                if !YPOINT_WGS.isEqual(nil){
                    elements.setObject(YPOINT_WGS, forKey: "YPOINT_WGS" as NSCopying)
                    lon = (YPOINT_WGS as NSString).doubleValue
                }
            }
            else if (isPosParsed == true){
                if !recptnDt.isEqual(nil){
                    elements.setObject(recptnDt, forKey: "recptnDt" as NSCopying)
                }
                if !arvlMsg2.isEqual(nil){
                    elements.setObject(arvlMsg2, forKey: "arvlMsg2" as NSCopying)
                }
                if !arvlMsg3.isEqual(nil){
                    elements.setObject(arvlMsg3, forKey: "arvlMsg3" as NSCopying)
                }
                if !trainLineNm.isEqual(nil){
                    elements.setObject(trainLineNm, forKey: "trainLineNm" as NSCopying)
                }
                if !subwayId.isEqual(nil){
                    elements.setObject(subwayId, forKey: "subwayId" as NSCopying)
                }

                posts.add(elements)
                counter += counter + 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources  that can be recreated.
    }
}
