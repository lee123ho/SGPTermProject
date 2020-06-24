//
//  Weather.swift
//  SGPTermProject
//
//  Created by KPU_GAME on 2020/06/11.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit
import SwiftUI
struct ParkInfo: View {
    var posts: NSMutableArray
  var station: WeatherStation
  
    var body: some View {
      //VStack {
        //StationHeader(station: self.station)
        TabView {
            PrecipitationTab(posts: self.posts)
            .tabItem({
              Image(systemName: "sun.dust")
              Text("미세 먼지")
            })
        }.frame(width: 400, height: 265)
        //}.navigationBarTitle(Text("\(station.name)"), displayMode: .inline).padding()
    }
}

struct ParkInfo_Previews: PreviewProvider {
    static var previews: some View {
        ParkInfo(posts: WeatherViewController().dustPosts, station: WeatherInformation()!.stations[0])
    }
}

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var WeatherTableView: UITableView!
    
    var cal : String = setDate().setCal()
    var hour : String = setDate().setHour()
    
    // url을 저장할 변수
    var url : String = "https://openapi.gg.go.kr/AWS1hourObser?KEY=56e5c933d8ae4be8b976b425ebd81d80&SIGUN_NM="
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    var dustParser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts : [String] = ["", "", ""]
    var dustPosts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var TP_INFO = NSMutableString()
    var RAINF_YN_INFO = NSMutableString()
    var WS_INFO = NSMutableString()
    var HD_INFO = NSMutableString()
    var gyeonggi = NSMutableString()
    var dataTime = NSMutableString()
    // row 개수 체크
    var row = 0
    // 시군 이름 저장
    var ssg = " "
    
    let postsname: [String] = ["기온", "풍속", "습도",]
    
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url+ssg+"&MESURE_DE="+cal+"&MESURE_TM="+hour))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func dustBeginParsing() {
        dustPosts = []
        dustParser = XMLParser(contentsOf: (URL(string:"http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?serviceKey=2fmtMuQnsvTBDYdGz7BeioMI87jvGCqbM5pkoS2WQxh26xwXkTgOfXt0t2ahSnHTbxHHG1MzWBqnr%2FM9gzE2Qg%3D%3D&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH&"))!)!
        dustParser.delegate = self
        dustParser.parse()
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
        
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            gyeonggi = NSMutableString()
            gyeonggi = ""
            dataTime = NSMutableString()
            dataTime = ""
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
        
        if element.isEqual(to: "dataTime")
        {
            dataTime.append(string)
        } else if element.isEqual(to: "gyeonggi")
        {
            gyeonggi.append(string)
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
        
        if (elementName as NSString).isEqual(to: "item") {
            if !dataTime.isEqual(nil)
            {
                elements.setObject(dataTime, forKey: "dataTime" as NSCopying)
            }
            if !gyeonggi.isEqual(nil)
            {
                elements.setObject(gyeonggi, forKey: "gyeonggi" as NSCopying)
            }
            
            dustPosts.add(elements)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherTableView.delegate = self
        WeatherTableView.dataSource = self
        beginParsing()
        dustBeginParsing()
        updateSwift()
    }
    
    func updateSwift() {
        let stations = WeatherInformation()
        
        let swiftUIController = UIHostingController(rootView: ParkInfo(posts: dustPosts, station: (stations?.stations[0])!))
        
        addChild(swiftUIController)
        swiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(swiftUIController.view)
        
        swiftUIController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swiftUIController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        swiftUIController.didMove(toParent: self)
    }
    
    func tableView(_ talbeView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = talbeView.dequeueReusableCell(withIdentifier: "WeatherCell")
        cell?.textLabel?.text = postsname[indexPath.row]
        cell?.detailTextLabel?.text = posts[indexPath.row]
        viewWeather()
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
        let RainState : Int = Int((RAINF_YN_INFO as String).filter("01234567890.".contains)) ?? -999
        var newImageView = UIImageView(image: UIImage(named: "number.png")!)
        if(RainState == 0) {
            newImageView = UIImageView(image: UIImage(named: "sun.png")!)  // 파일 이름으로 이미지 생성
        } else if (RainState == 1 || RainState == 10) {
            newImageView = UIImageView(image: UIImage(named: "rain.png")!)
        }
        newImageView.center = WeatherImage.center     // 카드 초기 위치는 카드 덱에서 시작
        newImageView.bounds.size = WeatherImage.bounds.size
        
        self.view.addSubview(newImageView)
    }
}
