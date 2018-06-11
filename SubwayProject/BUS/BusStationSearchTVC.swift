//
//  BusStationSearchTVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 19..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit
class stationCell : UITableViewCell{
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rotimage: UIImageView!
}

class BusStationSearchTVC: UITableViewController, XMLParserDelegate {
    @IBOutlet var DetailTable: UITableView!
    @IBOutlet weak var titleitem: UINavigationItem!
    @IBOutlet weak var BookmarkButton: UIBarButtonItem!
    @IBAction func AddBookmark(_ sender: Any) {
        if isBookmarked == true{
            Bookmark.Instance.removedata(name: routename)
            isBookmarked = false
            BookmarkButton.tintColor = UIColor.blue
            SoundManager.Instance.PlaySound(type: 0)
        }
        else {
            let data = bookmarkdata(_type: "BusRoute", _name: routename, _code: routeinput)
            Bookmark.Instance.savedata(data: data)
            BookmarkButton.tintColor = UIColor.red
            isBookmarked = true
            SoundManager.Instance.PlaySound(type: 1)
        }
    }
    
    var routeinput = ""
    var routename = ""
    
    var parsingval = 0
    var url : String?
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    var BusArrival = NSMutableArray()
    var arrivalcounter = 0
    
    var elements = NSMutableDictionary()
    var element = NSString()

    var stationNo = NSMutableString()
    var stationNm = NSMutableString()
    var transYn = NSMutableString()
    
    var sectOrd = NSMutableString()
    
    var selectedStationNo = ""
    
    var isBookmarked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleitem.title = routename
        
        for data in Bookmark.Instance.list {
            if data.name == routename {
                isBookmarked = true
                BookmarkButton.tintColor = UIColor.red
            }
        }
        
        url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&busRouteId=" + routeinput
        beginParsing()
        parsingval = 1
        arrivalcounter = 0
        url = "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&busRouteId=" + routeinput
        beginParsing()
    }

    func beginParsing(){
        if parsingval == 0 {
            posts = []
        }
        else if parsingval == 1 {
            BusArrival = []
        }
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        DetailTable.reloadData()
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchBusStationDetail"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                selectedStationNo = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey:"stationNo") as! NSString as String
                
                if let detailtableview = segue.destination as? StationDetailVC{
                    detailtableview.input = selectedStationNo
                }
            }
        }
        if segue.identifier == "BusRouteSearch"{
            if let viewController = segue.destination as? RouteMapVC{
                viewController.input = routeinput
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributeDict: [String:String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "itemList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            stationNo = NSMutableString()
            stationNo = ""
            stationNm = NSMutableString()
            stationNm = ""
            transYn = NSMutableString()
            transYn = ""
            
            sectOrd = NSMutableString()
            sectOrd = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "stationNo"){
            stationNo.append(string)
        }
        if element.isEqual(to: "stationNm"){
            stationNm.append(string)
        }
        if element.isEqual(to: "transYn"){
            transYn.append(string)
        }
        if element.isEqual(to: "sectOrd"){
            sectOrd.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "itemList"){
            if parsingval == 0 {
                if !stationNo.isEqual(nil){
                    elements.setObject(stationNo, forKey: "stationNo" as NSCopying)
                }
                if !stationNm.isEqual(nil){
                    elements.setObject(stationNm, forKey: "stationNm" as NSCopying)
                }
                if !transYn.isEqual(nil){
                    elements.setObject(transYn, forKey: "transYn" as NSCopying)
                }
                posts.add(elements)
            }
            else if parsingval == 1 {
                if !sectOrd.isEqual(nil){
                    elements.setObject(sectOrd, forKey: "sectOrd" as NSCopying)
                }
                BusArrival.add(elements)
                arrivalcounter+=1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        NSLog("You selected cell number: \(indexPath.row)!");
//
//        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertControllerStyle.actionSheet)
//        
//        let informantAction: UIAlertAction = UIAlertAction(title: "내용 신고하기", style: UIAlertActionStyle.destructive, handler:{
//            (action: UIAlertAction!) -> Void in
//            
//            print("내용 신고 알림 처리")
//        })
//        
//        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler:{
//            (action: UIAlertAction!) -> Void in
//            print("취소처리")
//        })
//        
//        alert.addAction(cancelAction)
//        alert.addAction(informantAction)
//        
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! stationCell
        
        let name = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationNm") as! NSString as String
        cell.name?.text = name
        
        if ((posts.object(at: indexPath.row) as AnyObject).value(forKey: "transYn") as! NSString as String) == "Y"{
            cell.rotimage?.image = UIImage(named: "rot.png")
        }
        else{
            cell.rotimage?.image = UIImage(named: "")
        }
        
        for index in 0..<BusArrival.count {
            let stidx = Int((BusArrival.object(at: index) as AnyObject).value(forKey: "sectOrd") as! NSString as String)
            if (stidx! - 1) == indexPath.row {
                cell.backgroundColor = UIColor.yellow
                cell.imageview?.image = UIImage(named: "busstop.png")
                break
            }
            else{
                cell.backgroundColor = UIColor.clear
                cell.imageview?.image = UIImage(named : "")
            }
        }
        
        
        
        return cell
    }
}
