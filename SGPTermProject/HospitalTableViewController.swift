//
//  HospitalTableViewController.swift
//  HospitalMap
//
//  Created by KPU_GAME on 2020/05/18.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit

class HospitalTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var tbData: UITableView!
    
    // url을 저장할 변수
    var url : String?
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var PARK_NM = NSMutableString()
    var REFINE_LOTNO_ADDR = NSMutableString()
    // 위도 경도 좌표 변수
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    // row 개수 체크
    var row = 0
    
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
            
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
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
        else if element.isEqual(to: "XPos")
        {
            XPos.append(string)
        } else if element.isEqual(to: "YPos")
        {
            YPos.append(string)
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
            if !XPos.isEqual(nil)
            {
                elements.setObject(PARK_NM, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil)
            {
                elements.setObject(REFINE_LOTNO_ADDR, forKey: "YPos" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "PARK_NM") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "REFINE_LOTNO_ADDR") as! NSString as String
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()

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
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*if segue.identifier == "segueToMapView"
        {
            if let mapViewController = segue.destination as? MapViewController
            {
                mapViewController.posts = posts
            }
        }*/
        
        if segue.identifier == "segueToHospitalDetail"
        {
            if let cell = sender as? UITableViewCell
            {
                let indexPath = tableView.indexPath(for: cell)
                row = indexPath!.row
                if let detailHospitalTableViewController = segue.destination as? DetailHospitalTableViewController
                {
                    detailHospitalTableViewController.rowCount = row
                    detailHospitalTableViewController.url = url!
                }
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
