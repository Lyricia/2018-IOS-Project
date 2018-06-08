//
//  BookmarkData.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 9..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import Foundation
import UIKit

class bookmarkdata: NSObject, NSCoding{
    
    var type : String = ""
    var name : String = ""
    var code : String = ""
    
    init(_type : String, _name : String, _code : String) {
        type = _type
        name = _name
        code = _code
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.code = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        self.type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.code, forKey: "code");
        aCoder.encode(self.type, forKey: "type");
    }
}

class Bookmark{
    static let Instance = Bookmark()
    @IBOutlet weak var TableView: UITableView!
    let defaults = UserDefaults.standard
    var list : [bookmarkdata] = []
    
    private init(){
        //savesamples()
        
        guard let data = UserDefaults.standard.object(forKey: "Bookmark") as? NSData else {
            print("'Bookmark' not found in UserDefaults")
            return
        }
        
        guard let bookmark = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [bookmarkdata] else {
            print("Could not unarchive from Bookmark")
            return
        }
        
        list = bookmark
    }
    
    func savesamples(){
        var arr : [bookmarkdata] = []
        arr.append(bookmarkdata(_type: "BusRoute", _name: "6000", _code: "100100411"))
        arr.append(bookmarkdata(_type: "BusRoute", _name: "광진01", _code: "104900005"))
        arr.append(bookmarkdata(_type: "BusStation", _name: "현대3차아파트", _code: "05533"))
        let data = NSKeyedArchiver.archivedData(withRootObject: arr)
        defaults.set(data, forKey: "Bookmark")
    }
    
    func removedata(name : String){
        for (index, data) in list.enumerated() {
            if data.name  == name {
                list.remove(at: index)
            }
        }
        update()   
    }
    
    func savedata(data : bookmarkdata){
        for idx in 0..<list.count{
            if list[idx].name == data.name{
                return
            }
        }
        list.append(data)
        update()
    }
    
    func update(){
        defaults.setValue(NSKeyedArchiver.archivedData(withRootObject: list), forKey: "Bookmark")
        if TableView != nil {
            TableView.reloadData()
        }
    }
}
