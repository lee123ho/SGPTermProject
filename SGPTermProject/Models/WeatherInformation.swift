/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class WeatherInformation {
  var stations: [WeatherStation]
  
  init?() {
    // Init empty array
    stations = []

    // Converter for date string
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yyyy"

    // Get CSV data
    guard let csvData = getCsvAsString() else { return nil }
    
    var currentStationId = ""
    var currentStation: WeatherStation?
    // Parse each line
    csvData.enumerateLines { (line, _) in
      let cols = line.components(separatedBy: ",")
      if currentStationId != cols[0] {
        if let newStation = currentStation {
          if(newStation.name != "NAME") {
            self.stations.append(newStation)
          }
        }
        
        currentStationId = cols[0]
        let name = cols[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ";", with: ",")
        let lat = Double(cols[2]) ?? 0
        let lng = Double(cols[3]) ?? 0
        let alt = Int((Double(cols[4]) ?? 0) * 3.28084) // m to ft.
        currentStation = WeatherStation(id: currentStationId, name: name, latitude: lat, longitude: lng, altitude: alt, measurements: [])
      }
      
      let date = dateFormatter.date(from: cols[5]) ?? dateFormatter.date(from: "1/1/2018")!
      let precip = Double(cols[6]) ?? 0
      let snow = Double(cols[7]) ?? 0
      let high = Double(cols[8]) ?? 0
      let low = Double(cols[9]) ?? 0
      let newData = DayInfo(date: date, precipitation: precip, snowfall: snow, high: high, low: low)
      
      currentStation?.measurements.append(newData)
    }
    // Add the last station read
    if let newStation = currentStation {
      self.stations.append(newStation)
    }
  }
  
  func getCsvAsString() -> String? {
    guard let fileURL = Bundle.main.url(forResource: "weather-data", withExtension: "csv") else { return nil }
    do {
      let csvData = try String(contentsOf: fileURL)
      return csvData
    } catch {
      return nil
    }
  }
}
