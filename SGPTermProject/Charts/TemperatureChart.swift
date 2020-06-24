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

struct TemperatureChart: View {
    var measurements: [DayInfo]
    
    func degreeHeight(_ height: CGFloat, range: Int) -> CGFloat {
        height / CGFloat(range)
    }
    
    func dayWidth(_ width: CGFloat, count: Int) -> CGFloat {
        width / CGFloat(count)
    }
    
    func dayOffSet(_ date: Date, dWidth: CGFloat) -> CGFloat {
        CGFloat(Calendar.current.ordinality(of: .day, in: .year, for: date)!) * dWidth
    }
    
    func tempOffSet(_ temperature: Double, degreeHeigth: CGFloat) -> CGFloat {
        CGFloat(temperature + 10) * degreeHeigth
    }
    
    let tempGradient = Gradient(colors: [
        .purple,
        Color(red: 0, green: 0, blue: 139.0/255.0),
        .blue,
        Color(red: 30.0/255.0, green: 144.0/255.0, blue: 1.0),
        Color(red: 0, green: 191/255.0, blue: 1.0),
        Color(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0),
        .green,
        .yellow,
        .orange,
        Color(red: 1.0, green: 140.0/255.0, blue: 0.0),
        .red,
        Color(red: 139.0/255.0, green: 0.0, blue: 0.0),
    ])
    
    func tempLabelOffset(_ line: Int, height: CGFloat) -> CGFloat {
        height - self.tempOffSet(
            Double(line * 10),
            degreeHeigth: self.degreeHeight(height, range: 110))
    }
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        GeometryReader { reader in
            ForEach(self.measurements) { measurements in
                Path { p in
                    let dWidth = self.dayWidth(reader.size.width, count: 365)
                    let dHeight = self.degreeHeight(reader.size.height, range: 110)
                    let dOffset = self.dayOffSet(measurements.date, dWidth: dWidth)
                    let lowOffset = self.tempOffSet(measurements.low, degreeHeigth: dHeight)
                    let highOffset = self.tempOffSet(measurements.high, degreeHeigth: dHeight)
                    p.move(to: CGPoint(x: dOffset, y: reader.size.height - lowOffset))
                    p.addLine(to: CGPoint(x: dOffset, y: reader.size.height - highOffset))
                }.stroke(LinearGradient(
                    gradient: self.tempGradient,
                    startPoint: UnitPoint(x: 0.0, y: 1.0),
                    endPoint: UnitPoint(x: 0.0, y: 0.0)))
            }
            ForEach(-1..<11) {line in
                Group {
                    Path { path in
                        let y = self.tempLabelOffset(line, height: reader.size.height)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: reader.size.width
                            , y: y))
                    }.stroke(line == 0 ? Color.black : Color.gray)
                    if line >= 0 {
                        Text("\(line * 10)")
                            .offset(x: 10, y: self.tempLabelOffset(line, height: reader.size.height))
                    }
                }
            }
        }
    }
}

struct TemperatureChart_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureChart(measurements: WeatherInformation()!.stations[1].measurements)
    }
}
