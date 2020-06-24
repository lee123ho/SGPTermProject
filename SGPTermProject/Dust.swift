//
//  Dust.swift
//  SGPTermProject
//
//  Created by KPU_GAME on 2020/06/24.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import Foundation
import UIKit

class Dust: XMLParser, XMLParserDelegate {
    // url을 저장할 변수
    var url : String = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?serviceKey=2fmtMuQnsvTBDYdGz7BeioMI87jvGCqbM5pkoS2WQxh26xwXkTgOfXt0t2ahSnHTbxHHG1MzWBqnr%2FM9gzE2Qg%3D%3D&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH&"
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var gyeonggi = NSMutableString()
    
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:"http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?serviceKey=2fmtMuQnsvTBDYdGz7BeioMI87jvGCqbM5pkoS2WQxh26xwXkTgOfXt0t2ahSnHTbxHHG1MzWBqnr%2FM9gzE2Qg%3D%3D&numOfRows=10&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH&"))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            gyeonggi = NSMutableString()
            gyeonggi = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "gyeonggi")
        {
            gyeonggi.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !gyeonggi.isEqual(nil)
            {
                elements.setObject(gyeonggi, forKey: "gyeonggi" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
}
