//
//  SubwayLineData.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 7..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import Foundation

let linename = [
    "1호선",
    "2호선",
    "3호선",
    "4호선",
    "5호선",
    "6호선",
    "7호선",
    "8호선",
    "9호선",
    "경의중앙선",
    "경춘선",
    "분당선",
    "용인경전철",
    "수인선",
    "신분당선",
    "의정부경전철",
    "경강선",
    "공항철도",
    "인천1호선",
    "인천2호선"
]
let linecodematcher = [
    "1" : "1호선",
    "2" : "2호선",
    "3" : "3호선",
    "4" : "4호선",
    "5" : "5호선",
    "6" : "6호선",
    "7" : "7호선",
    "8" : "8호선",
    "9" : "9호선",
    "K" : "경의중앙선",
    "G" : "경춘선",
    "B" : "분당선",
    "E" : "용인경전철",
    "SU": "수인선",
    "S" : "신분당선",
    "U" : "의정부경전철",
    "KK": "경강선",
    "A" : "공항철도",
    "I" : "인천1호선",
    "I2": "인천2호선"
]



var line1 = [[:]]
var line2 = [[:]]
var line3 = [[:]]
var line4 = [[:]]
var line5 = [[:]]
var line6 = [[:]]
var line7 = [[:]]
var line8 = [[:]]
var line9 = [[:]]
var lineK = [[:]]   //경의중앙선
var lineG = [[:]]   //경춘선
var lineB = [[:]]   //분당선
var lineE = [[:]]   //용인경전철
var lineSU = [[:]]  //수인선
var lineS = [[:]]   //신분당선
var lineU = [[:]]   //의정부경전철
var lineKK = [[:]]  //경강선
var lineA = [[:]]   //공항철도
var lineI = [[:]]   //인천1호선
var lineI2 = [[:]]  //인천2호선

let path = Bundle.main.path(forResource: "SubDB", ofType: "json")

var dataloaded = false

var lineall = [[:]]

func CollapseAllData() {
    lineall.remove(at: 0)
    lineall.append(contentsOf: line1)
    lineall.append(contentsOf: line2)
    lineall.append(contentsOf: line3)
    lineall.append(contentsOf: line4)
    lineall.append(contentsOf: line5)
    lineall.append(contentsOf: line6)
    lineall.append(contentsOf: line7)
    lineall.append(contentsOf: line8)
    lineall.append(contentsOf: line9)
    lineall.append(contentsOf: lineK )
    lineall.append(contentsOf: lineG )
    lineall.append(contentsOf: lineB )
    lineall.append(contentsOf: lineE )
    lineall.append(contentsOf: lineSU)
    lineall.append(contentsOf: lineS )
    lineall.append(contentsOf: lineU )
    lineall.append(contentsOf: lineKK)
    lineall.append(contentsOf: lineA )
    lineall.append(contentsOf: lineI )
    lineall.append(contentsOf: lineI2)
}

func findStation(code : String) -> [AnyHashable : Any]{
    var result = [AnyHashable : Any]()
    
    for data in lineall{
        if (data["fr_code"] as! String) == code{
            result = data
        }
    }
    
    return result
}

func findStations(name : String) -> [[AnyHashable : Any]]{
    var datalist = [[:]]
    datalist.remove(at: 0)
    
    for data in lineall{
        if ((data["station_nm"] as! String).contains(name)){
            datalist.append(data)
        }
    }
    
    return datalist
}

func getLineData(name : String) -> [[AnyHashable : Any]]{
    var linetarget = [[:]]
    switch name {
    case "1호선":
        linetarget = line1
        break
    case "2호선":
        linetarget = line2
        break
    case "3호선":
        linetarget = line3
        break
    case "4호선":
        linetarget = line4
        break
    case "5호선":
        linetarget = line5
        break
    case "6호선":
        linetarget = line6
        break
    case "7호선":
        linetarget = line7
        break
    case "8호선":
        linetarget = line8
        break
    case "9호선":
        linetarget = line9
        break
    case "경의중앙선":
        linetarget = lineK
        break
    case "경춘선":
        linetarget = lineG
        break
    case "분당선":
        linetarget = lineB
        break
    case "용인경전철":
        linetarget = lineE
        break
    case "수인선":
        linetarget = lineSU
        break
    case "신분당선":
        linetarget = lineS
        break
    case "의정부경전철":
        linetarget = lineU
        break
    case "경강선":
        linetarget = lineKK
        break
    case "공항철도":
        linetarget = lineA
        break
    case "인천1호선":
        linetarget = lineI
        break
    case "인천2호선":
        linetarget = lineI2
        break
    default: break
    }
    return linetarget
}


func loadData()
{
    line1.remove(at: 0)
    line2.remove(at: 0)
    line3.remove(at: 0)
    line4.remove(at: 0)
    line5.remove(at: 0)
    line6.remove(at: 0)
    line7.remove(at: 0)
    line8.remove(at: 0)
    line9.remove(at: 0)
    lineK.remove(at: 0)
    lineG.remove(at: 0)
    lineB.remove(at: 0)
    lineSU.remove(at: 0)
    lineU.remove(at: 0)
    lineKK.remove(at: 0)
    lineA.remove(at: 0)
    lineI.remove(at: 0)
    lineE.remove(at: 0)
    lineI2.remove(at: 0)
    lineS.remove(at: 0)
    
    do{
        let Rawdata = try String(contentsOfFile: path!).data(using: .utf8)
        
        let json = try JSONSerialization.jsonObject(with: Rawdata!, options: []) as! [String:Any]
        
        let data =  json["DATA"] as? [[String: String]]
        
        for station in data! {
            if station["line_num"] == "1" {
                line1.append(station)
            }
            else if station["line_num"] == "2" {
                line2.append(station)
            }
            else if station["line_num"] == "3" {
                line3.append(station)
            }
            else if station["line_num"] == "4" {
                line4.append(station)
            }
            else if station["line_num"] == "5" {
                line5.append(station)
            }
            else if station["line_num"] == "6" {
                line6.append(station)
            }
            else if station["line_num"] == "7" {
                line7.append(station)
            }
            else if station["line_num"] == "8" {
                line8.append(station)
            }
            else if station["line_num"] == "9" {
                line9.append(station)
            }
            else if station["line_num"] == "K" {
                lineK.append(station)
            }
            else if station["line_num"] == "G" {
                lineG.append(station)
            }
            else if station["line_num"] == "B" {
                lineB.append(station)
            }
            else if station["line_num"] == "SU" {
                lineSU.append(station)
            }
            else if station["line_num"] == "U" {
                lineU.append(station)
            }
            else if station["line_num"] == "KK" {
                lineKK.append(station)
            }
            else if station["line_num"] == "A" {
                lineA.append(station)
            }
            else if station["line_num"] == "I" {
                lineI.append(station)
            }
            else if station["line_num"] == "E" {
                lineE.append(station)
            }
            else if station["line_num"] == "I2" {
                lineI2.append(station)
            }
            else if station["line_num"] == "S" {
                lineS.append(station)
            }
        }
    }
    catch{
        print(error)
    }
}
