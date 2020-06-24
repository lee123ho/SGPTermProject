//
//  HospitalTableViewController.swift
//  HospitalMap
//
//  Created by KPU_GAME on 2020/05/18.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit

struct ParkStruct {
    var name : String
    var add : String
    var row : Int
}

class HospitalTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var tbData: UITableView!
    
    // url을 저장할 변수
    var url : String?
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    var filteredposts = NSMutableArray()
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var PARK_NM = NSMutableString()
    var REFINE_LOTNO_ADDR = NSMutableString()
    // 위도 경도 좌표 변수
    var REFINE_WGS84_LAT = NSMutableString()
    var REFINE_WGS84_LOGT = NSMutableString()
    // row 개수 체크
    var row = 0
    var filterRow = 0
    
    var ssg = " "
    
    var parkInfose = [ParkStruct]()
    var filterParkInfo = [ParkStruct]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            PARK_NM = NSMutableString()
            PARK_NM = ""
            REFINE_LOTNO_ADDR = NSMutableString()
            REFINE_LOTNO_ADDR = ""
            
            REFINE_WGS84_LAT = NSMutableString()
            REFINE_WGS84_LAT = ""
            REFINE_WGS84_LOGT = NSMutableString()
            REFINE_WGS84_LOGT = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "PARK_NM")
        {
            PARK_NM.append(string)
        } else if element.isEqual(to: "REFINE_LOTNO_ADDR")
        {
            REFINE_LOTNO_ADDR.append(string)
        }
        else if element.isEqual(to: "REFINE_WGS84_LOGT")
        {
            REFINE_WGS84_LOGT.append(string)
        } else if element.isEqual(to: "REFINE_WGS84_LAT")
        {
            REFINE_WGS84_LAT.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "row") {
            if !PARK_NM.isEqual(nil)
            {
                elements.setObject(PARK_NM, forKey: "PARK_NM" as NSCopying)
            }
            if !REFINE_LOTNO_ADDR.isEqual(nil)
            {
                elements.setObject(REFINE_LOTNO_ADDR, forKey: "REFINE_LOTNO_ADDR" as NSCopying)
            }
            if !REFINE_WGS84_LOGT.isEqual(nil)
            {
                elements.setObject(REFINE_WGS84_LOGT, forKey: "REFINE_WGS84_LOGT" as NSCopying)
            }
            if !REFINE_WGS84_LAT.isEqual(nil)
            {
                elements.setObject(REFINE_WGS84_LAT, forKey: "REFINE_WGS84_LAT" as NSCopying)
            }
            
            parkInfose.append(ParkStruct(name: elements.object(forKey: "PARK_NM") as! String, add: elements.object(forKey: "REFINE_LOTNO_ADDR") as! String, row: filterRow))
            
            filterRow += 1
            
            posts.add(elements)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if isFiltering() {
            cell.textLabel?.text = filterParkInfo[indexPath.row].name
            cell.detailTextLabel?.text = filterParkInfo[indexPath.row].add
        } else {
            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "PARK_NM") as! NSString as String
            cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "REFINE_LOTNO_ADDR") as! NSString as String
        }
        
        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterParkInfo = parkInfose.filter({( park: ParkStruct ) -> Bool in
            return park.add.contains(searchText) || park.name.contains(searchText)
        })
        
        tbData.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Park Name or Address"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filterParkInfo.count
        }
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToMapView"
        {
            if let mapViewController = segue.destination as? MapViewController
            {
                mapViewController.posts = posts
            }
        }
        
        if segue.identifier == "segueToHospitalDetail"
        {
            if let cell = sender as? UITableViewCell
            {
                let indexPath = tableView.indexPath(for: cell)
                if isFiltering() {
                    row = filterParkInfo[indexPath!.row].row
                } else {
                    row = indexPath!.row
                }
                if let detailHospitalTableViewController = segue.destination as? DetailHospitalTableViewController
                {
                    detailHospitalTableViewController.rowCount = row
                    detailHospitalTableViewController.url = url!
                    detailHospitalTableViewController.ssg = ssg
                }
            }
        }
    }
}

extension HospitalTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
