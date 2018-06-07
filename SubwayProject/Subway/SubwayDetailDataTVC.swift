//
//  SubwayDetailDataTBC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 8..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class SubwayDetailDataTBC: UITableViewController, XMLParserDelegate  {
    @IBOutlet var DetailTable: UITableView!
    
    var datalist = [[:]]
    var input = ""
    
    override func viewDidLoad() {
        datalist = findStation(name: input)

        super.viewDidLoad()
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchSubStationDetail"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                let code = datalist[indexPath!.row]["fr_code"] as? String
                if let ViewController = segue.destination as? SubStationDetailVC{
                    ViewController.code = code!
                    ViewController.StationData = datalist[(indexPath?.row)!]
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
        return datalist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = datalist[indexPath.row]
        cell.textLabel?.text = object["station_nm"] as? String
        cell.detailTextLabel?.text = linecodematcher[(object["line_num"] as? String)!]
        
        return cell
    }
}
