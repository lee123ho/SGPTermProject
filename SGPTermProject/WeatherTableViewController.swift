//
//  Weather.swift
//  SGPTermProject
//
//  Created by KPU_GAME on 2020/06/11.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var WeatherTableView: UITableView!
    
    // url을 저장할 변수
    var url = "https://openapi.gg.go.kr/AWS1hourObser?KEY=56e5c933d8ae4be8b976b425ebd81d80&SIGUN_NM="
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts : [String] = ["", "", ""]
    var element = NSString()
    // 저장 문자열 변수
    var TP_INFO = NSMutableString()
    var RAINF_YN_INFO = NSMutableString()
    var WS_INFO = NSMutableString()
    var HD_INFO = NSMutableString()
    // row 개수 체크
    var row = 0
    // 시군 이름 저장
    var ssg = " "
    
    let postsname: [String] = ["기온", "풍속", "습도",]
    
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "row")
        {
            posts = ["", "", ""]
            
            TP_INFO = NSMutableString()
            TP_INFO = ""
            RAINF_YN_INFO = NSMutableString()
            RAINF_YN_INFO = ""
            
            WS_INFO = NSMutableString()
            WS_INFO = ""
            HD_INFO = NSMutableString()
            HD_INFO = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "TP_INFO")
        {
            TP_INFO.append(string)
        } else if element.isEqual(to: "RAINF_YN_INFO")
        {
            RAINF_YN_INFO.append(string)
        }
        else if element.isEqual(to: "WS_INFO")
        {
            WS_INFO.append(string)
        } else if element.isEqual(to: "HD_INFO")
        {
            HD_INFO.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "row") {
            if !TP_INFO.isEqual(nil)
            {
                posts[0] = TP_INFO as String
            }
            if !WS_INFO.isEqual(nil)
            {
                posts[1] = WS_INFO as String
            }
            if !HD_INFO.isEqual(nil)
            {
                posts[2] = HD_INFO as String
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        viewWeather()
    }
    
    func tableView(_ talbeView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = talbeView.dequeueReusableCell(withIdentifier: "WeatherCell")
        cell?.textLabel?.text = postsname[indexPath.row]
        cell?.detailTextLabel?.text = posts[indexPath.row]
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    func viewWeather() {
        let newImageView = UIImageView(image: UIImage(named: "sun.png")!)  // 파일 이름으로 이미지 생성
        newImageView.center = WeatherImage.center     // 카드 초기 위치는 카드 덱에서 시작
        
        self.view.addSubview(newImageView)
    }
    
    func setCal() -> Int {
        let formatter_Cal = DateFormatter()
        formatter_Cal.dateFormat = "yyyyMMdd"
        let cal = formatter_Cal.string(from: Date())
        let calNum = Int(cal)!
        
        return calNum
    }
    
    func setHour() -> Int {
        let formatter_hour = DateFormatter()
        formatter_hour.dateFormat = "HH"
        let rHour = formatter_hour.string(from: Date())
        
        let pHour : Int = Int(rHour)! - 1
        
        return pHour
    }

}
