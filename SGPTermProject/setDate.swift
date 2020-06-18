//
//  setDate.swift
//  SGPTermProject
//
//  Created by KPU_GAME on 2020/06/18.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import Foundation

class setDate {
    var cal: String
    var hour: String
    
    init() {
        self.cal = " "
        self.hour = " "
    }
    
    func setCal() -> String {
        let formatter_Cal = DateFormatter()
        formatter_Cal.dateFormat = "yyyyMMdd"
        self.cal = formatter_Cal.string(from: Date())
        
        return self.cal
    }
    
    func setHour() -> String {
        let formatter_hour = DateFormatter()
        formatter_hour.dateFormat = "HH"
        let rHour = formatter_hour.string(from: Date())
        let pHour = Int(rHour)! - 1
        self.hour = String(format: "%02d", pHour)
        
        return self.hour
    }
}
