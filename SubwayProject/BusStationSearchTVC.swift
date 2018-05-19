//
//  BusStationSearchTVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 19..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit


class BusStationSearchTVC: UITableViewController, XMLParserDelegate {
    @IBOutlet var DetailTable: UITableView!
    
    var input = ""
    var url : String?
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()

    var stationNo = NSMutableString()
    var stationNm = NSMutableString()
    
    var selectedStationNo = ""
    
    override func viewDidLoad() {
        url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&busRouteId=" + input
        super.viewDidLoad()
        beginParsing()
        

    }

    func beginParsing(){
        posts = []
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
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "itemList"){
            if !stationNo.isEqual(nil){
                elements.setObject(stationNo, forKey: "stationNo" as NSCopying)
            }
            if !stationNm.isEqual(nil){
                elements.setObject(stationNm, forKey: "stationNm" as NSCopying)
            }
            posts.add(elements)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationNm") as! NSString as String
        
        return cell
    }
}
