//
//  DetailHospitalTableViewController.swift
//  HospitalMap
//
//  Created by KPU_GAME on 2020/05/19.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit

class DetailHospitalTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    // 날씨 Parser
    var weatherParser = XMLParser()
    
    let postsname: [String] = ["공원명", "공원 구분", "주소", "공원 면적", "운동시설", "유희시설", "편익시설", "교양시설", "기타시설", "관리 기관", "전화번호"]
    
    var posts : [String] = ["", "", "", "", "", "", "", "", "", "", ""]
    var selectPosts : [String] = ["", "", "", "", "", "", "", "", "", "", ""]
    
    var element = NSString()
    var PARK_NM = NSMutableString()
    var REFINE_LOTNO_ADDR = NSMutableString()
    var MANAGE_INST_TELNO = NSMutableString()
    var PARK_DIV_NM = NSMutableString()
    var PARK_AR = NSMutableString()
    var PARK_SPORTS_FACLT_DTLS = NSMutableString()
    var PARK_AMSMT_FACLT_DTLS = NSMutableString()
    var PARK_CNVNC_FACLT_DTLS = NSMutableString()
    var PARK_CLTR_FACLT_DTLS = NSMutableString()
    var PARK_ETC_FACLT_DTLS = NSMutableString()
    var MANAGE_INST_NM = NSMutableString()
    // row 개수 체크
    var rowCount : Int?
    var row = 0
    // 시군 이름 저장
    var ssg = " "
    
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "row")
        {
            posts = ["", "", "", "", "", "", "", "", "", "", ""]
            
            PARK_NM = NSMutableString()
            PARK_NM = ""
            REFINE_LOTNO_ADDR = NSMutableString()
            REFINE_LOTNO_ADDR = ""
            MANAGE_INST_TELNO = NSMutableString()
            MANAGE_INST_TELNO = ""
            PARK_DIV_NM = NSMutableString()
            PARK_DIV_NM = ""
            PARK_AR = NSMutableString()
            PARK_AR = ""
            PARK_SPORTS_FACLT_DTLS = NSMutableString()
            PARK_SPORTS_FACLT_DTLS = ""
            PARK_AMSMT_FACLT_DTLS = NSMutableString()
            PARK_AMSMT_FACLT_DTLS = ""
            PARK_CNVNC_FACLT_DTLS = NSMutableString()
            PARK_CNVNC_FACLT_DTLS = ""
            PARK_CLTR_FACLT_DTLS = NSMutableString()
            PARK_CLTR_FACLT_DTLS = ""
            PARK_ETC_FACLT_DTLS = NSMutableString()
            PARK_ETC_FACLT_DTLS = ""
            MANAGE_INST_NM = NSMutableString()
            MANAGE_INST_NM = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "PARK_NM")
        {
            PARK_NM.append(string)
        } else if element.isEqual(to: "REFINE_LOTNO_ADDR")
        {
            REFINE_LOTNO_ADDR.append(string)
        } else if element.isEqual(to: "MANAGE_INST_TELNO")
        {
            MANAGE_INST_TELNO.append(string)
        } else if element.isEqual(to: "PARK_DIV_NM")
        {
            PARK_DIV_NM.append(string)
        } else if element.isEqual(to: "PARK_AR")
        {
            PARK_AR.append(string)
        } else if element.isEqual(to: "PARK_SPORTS_FACLT_DTLS")
        {
            PARK_SPORTS_FACLT_DTLS.append(string)
        } else if element.isEqual(to: "PARK_AMSMT_FACLT_DTLS")
        {
            PARK_AMSMT_FACLT_DTLS.append(string)
        } else if element.isEqual(to: "PARK_CNVNC_FACLT_DTLS")
        {
            PARK_CNVNC_FACLT_DTLS.append(string)
        } else if element.isEqual(to: "PARK_CLTR_FACLT_DTLS")
        {
            PARK_CLTR_FACLT_DTLS.append(string)
        } else if element.isEqual(to: "PARK_ETC_FACLT_DTLS")
        {
            PARK_ETC_FACLT_DTLS.append(string)
        } else if element.isEqual(to: "MANAGE_INST_NM")
        {
            MANAGE_INST_NM.append(string)
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "row") && row == rowCount {
            if !PARK_NM.isEqual(nil)
            {
                posts[0] = PARK_NM as String
            }
            if !REFINE_LOTNO_ADDR.isEqual(nil)
            {
                posts[2] = REFINE_LOTNO_ADDR as String
            }
            if !MANAGE_INST_TELNO.isEqual(nil)
            {
                posts[10] = MANAGE_INST_TELNO as String
            }
            if !PARK_DIV_NM.isEqual(nil)
            {
                posts[1] = PARK_DIV_NM as String
            }
            if !PARK_AR.isEqual(nil)
            {
                posts[3] = PARK_AR as String
            }
            if !PARK_SPORTS_FACLT_DTLS.isEqual(nil)
            {
                posts[4] = PARK_SPORTS_FACLT_DTLS as String
            }
            if !PARK_AMSMT_FACLT_DTLS.isEqual(nil)
            {
                posts[5] = PARK_AMSMT_FACLT_DTLS as String
            }
            if !PARK_CNVNC_FACLT_DTLS.isEqual(nil)
            {
                posts[6] = PARK_CNVNC_FACLT_DTLS as String
            }
            if !PARK_CLTR_FACLT_DTLS.isEqual(nil)
            {
                posts[7] = PARK_CLTR_FACLT_DTLS as String
            }
            if !PARK_ETC_FACLT_DTLS.isEqual(nil)
            {
                posts[8] = PARK_ETC_FACLT_DTLS as String
            }
            if !MANAGE_INST_NM.isEqual(nil)
            {
                posts[9] = MANAGE_INST_NM as String
            }
            selectPosts = posts
        }
        if (elementName as NSString).isEqual(to: "row"){
            row += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ talbeView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = selectPosts[indexPath.row]
        return cell
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
        if segue.identifier == "sequeToWeather"
        {
            
                if let weatherViewController = segue.destination as? WeatherViewController
                {
                    weatherViewController.ssg = ssg
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
