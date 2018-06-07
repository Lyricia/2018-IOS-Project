//
//  DetailDataTableViewController.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 1..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class DetailDataTableViewController: UITableViewController, XMLParserDelegate {
    
    @IBOutlet var DetailTable: UITableView!
    
    var input = ""
    var input_uft8 = ""
    var url : String?
    
    var selectedRouteId = ""
    var selectedRouteName = ""
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    var busRouteNm = NSMutableString()
    var busRouteId = NSMutableString()
    
    override func viewDidLoad() {
        input_uft8 = input.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?serviceKey=hhMaFcQqWZECMqbHc3G%2BhOy1odmISfqSHDq1oejzW2%2Fsrln0q%2BIDKNQgYXX2B%2B5mHYvDqE7LXtkyLrJWDcacUg%3D%3D&strSrch=" + input_uft8
        
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
        if segue.identifier == "SearchBusStation"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                selectedRouteId = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey:"busRouteId") as! NSString as String
                selectedRouteName = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey:"busRouteNm") as! NSString as String
                if let detailtableview = segue.destination as? BusStationSearchTVC{
                    detailtableview.routeinput = selectedRouteId
                    detailtableview.routename = selectedRouteName
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
            busRouteNm = NSMutableString()
            busRouteNm = ""
            busRouteId = NSMutableString()
            busRouteId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string:String)
    {
        if element.isEqual(to: "busRouteNm"){
            busRouteNm.append(string)
        }
        if element.isEqual(to: "busRouteId"){
            busRouteId.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "itemList"){
            if !busRouteNm.isEqual(nil){
                elements.setObject(busRouteNm, forKey: "busRouteNm" as NSCopying)
            }
            if !busRouteId.isEqual(nil){
                elements.setObject(busRouteId, forKey: "busRouteId" as NSCopying)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "busRouteNm") as! NSString as String
        
        return cell
    }
}
