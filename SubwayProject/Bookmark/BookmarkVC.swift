    //
//  BookmarkVC.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 5. 21..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import UIKit

class BookmarkVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{

    @IBOutlet weak var TableView: UITableView!
    var searchController : UISearchController!
    var selectedData : bookmarkdata!
    
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var codelabel: UILabel!
    
    @IBAction func DoSearch(_ sender: Any) {
        searchController.isActive = false
        shouldShowSearchResults = false
        TableView.reloadData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if selectedData.type == "BusRoute" {
            let targetVC = storyboard.instantiateViewController(withIdentifier: "StationVC") as! BusStationSearchTVC
            targetVC.routeinput = selectedData.code
            targetVC.routename = selectedData.name
            navigationController?.pushViewController(targetVC, animated: true)
        }
        else if selectedData.type == "BusStation" {
            let targetVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! StationDetailVC
            targetVC.input = selectedData.code
            navigationController?.pushViewController(targetVC, animated: true)
        }
        else if selectedData.type == "SubStation" {
            let targetVC = storyboard.instantiateViewController(withIdentifier: "SubStationVC") as! SubStationDetailVC
            targetVC.StationData = findStation(code : selectedData.code)
            navigationController?.pushViewController(targetVC, animated: true)
        }
    }
    
    
    @IBAction func RemoveBookmark(_ sender: Any) {
        if (selectedidx == -1){
            return
        }
        Bookmark.Instance.list.remove(at: selectedidx)
        Bookmark.Instance.update()
        selectedidx = -1
        typelabel.text = ""
        namelabel.text = ""
        codelabel.text = ""
    }
    
    var selectedidx = -1
    var filteredArr = [bookmarkdata]()
    var shouldShowSearchResults = false
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        Bookmark.Instance.TableView = TableView
        filteredArr = Bookmark.Instance.list
        SearchControllerConfig()
        
        TableView.reloadData()
        
    }
    
    func SearchControllerConfig(){
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Place the search bar view to the tableview headerview.
        TableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        TableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        TableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
        }
        
        searchController.searchBar.resignFirstResponder()
    }
        
    func updateSearchResults(for searchController: UISearchController) {
        let input = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArr = Bookmark.Instance.list.filter({ (data) -> Bool in
            let name: NSString = data.name as NSString
            
            return (name.range(of: input!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        TableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data : bookmarkdata
        if shouldShowSearchResults {
            data = filteredArr[indexPath.row]
        }
        else {
            data = Bookmark.Instance.list[indexPath.row]
        }
        selectedData = data
        typelabel.text = data.type
        namelabel.text = data.name
        codelabel.text = data.code
    }
    
    // 테이블 행수 얻기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArr.count
        }
        else {
            return Bookmark.Instance.list.count
        }
    }

    // 셀 내용 변경하기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArr[indexPath.row].name
        }
        else {
            cell.textLabel?.text = Bookmark.Instance.list[indexPath.row].name
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
