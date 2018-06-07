//
//  StationListTBC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 7..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class StationListTBC: UITableViewController, XMLParserDelegate {

    @IBOutlet var ListTable: UITableView!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    var linenm : String = ""
    var linedata = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linedata = getLineData(name: linenm)
        naviItem.title = linenm

        print(linedata.count)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchSubStationDetail"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                let object = linedata[indexPath!.row]
                if let ViewController = segue.destination as? SubStationDetailVC{
                    ViewController.StationData = object
                }
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
        // #warning Incomplete implementation, return the number of rows
        return linedata.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = linedata[indexPath.row]
        cell.textLabel?.text = object["station_nm"] as? String
        return cell
    }
}
