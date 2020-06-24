/// Copyright (c) 2020 Razeware LLC
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

import SwiftUI

struct SnowFallChart: View {
    var measurements: [DayInfo]
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        List(measurements.filter{$0.snowfall > 0.0}) { measurement in
            HStack {
                Text("\(measurement.dateString)")
                    .frame(width: 100, alignment: .trailing)
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: CGFloat(measurement.snowfall * 10.0), height: 5.0)
                    ForEach(0..<17) {mark in
                        Rectangle()
                            .fill(mark % 5 == 0 ? Color.black : Color.gray)
                            .offset(x: CGFloat(mark) * 10.0)
                            .frame(width: 1.0)
                            .zIndex(1)
                    }
                }
                Spacer()
                Text("\(measurement.snowfall.stringToOneDecimal)\"")
            }
        }
    }
}

struct SnowFallChart_Previews: PreviewProvider {
    static var previews: some View {
        //SnowFallChart()
        SnowFallChart(measurements: WeatherInformation()!.stations[2].measurements)
    }
}
