//
//  ContentView.swift
//  PieChart
//
//  Created by 김정민 on 2021/08/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.black)
                    })
                }
                
                Text("My Usage")
                    .fontWeight(.bold)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .overlay(Rectangle().stroke(Color.black.opacity(0.05), lineWidth: 2))
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<data.count) { i in
                        DrawShape(center: CGPoint(x: geometry.frame(in: .global).width / 2, y: geometry.frame(in: .global).height / 2), index: i)
                    }
                }
            }
            .frame(height: 360)
            .padding(.top, 20)
            // since it is in circle shape so we're going to clip it in circle
            .clipShape(Circle())
            .shadow(radius: 8)
            
            VStack {
                ForEach(data) { i in
                    HStack {
                        Text(i.name)
                            .frame(width: 100)
                        
                        // fixed width
                        
                        GeometryReader { geometry in
                            HStack {
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: geometry.frame(in: .global).width, value: i.percent) ,height: 10)
                                
                                Text(String(format: "\(i.percent)", "%.0f"))
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                            }
                        }
                    }
                    .padding(.top, 18)
                }
            }
            .padding()
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func getWidth(width: CGFloat, value: CGFloat) -> CGFloat {
        let temp = value / 100
        return temp * width
    }
}

struct DrawShape: View {
    var center: CGPoint
    var index: Int
    
    var body: some View {
        Path { path in
            path.move(to: self.center)
            path.addArc(center: self.center, radius: 180, startAngle: .init(degrees: from()), endAngle: .init(degrees: self.to()), clockwise: false)
        }
        .fill(data[index].color)
    }
    
    
    // since angle is continuos so we need to calculate the angles before and add with the current to get exact angle
    func from() -> Double {
        if index == 0 {
            return 0
        } else {
            var temp: Double = 0
            
            for i in 0...index-1 {
                temp += Double(data[i].percent / 100) * 360
            }
            return temp
        }
    }
    
    func to() -> Double {
        // converting percentage to angle
        var temp: Double = 0
        
        // because we need the current degree
        for i in 0...index {
            temp += Double(data[i].percent / 100) * 360
        }
        return temp
    }
}

// Sample Data
struct Pie: Identifiable {
    var id: Int
    var percent: CGFloat
    var name: String
    var color: Color
}

var data = [
    Pie(id: 0, percent: 10, name: "ObjcC", color: Color("Color")),
    Pie(id: 1, percent: 15, name: "Swift", color: Color("Color1")),
    Pie(id: 2, percent: 20, name: "Java", color: Color("Color2")),
    Pie(id: 3, percent: 20, name: "Flutter", color: Color("Color3")),
    Pie(id: 4, percent: 35, name: "SwiftUI", color: Color.green.opacity(0.6))
]
