//
//  Clock.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/11/24.
//
//  Referenced Circle Data from https://github.com/kenfai/KavSoft-Tutorials-iOS/tree/main/CircularSlider
//

import SwiftUI

struct Clock: View {
    @State private var totalAngle: Double = 0
    @State private var startAngle: Double = 0
    @State private var initialDragAngle: Double = 0
    @State var progress: CGFloat = 0
    @State private var counter = 0

    var body: some View {
        VStack {
            Text("Time Exercised")
                .fontWeight(.bold)
                .modifier(BlueGradientTextStyle())
            // Selected Time
            Text(timeString(from: totalAngle))
                .font(.largeTitle)
                .fontWeight(.bold)
                .modifier(BlueGradientTextStyle())
                .padding(.bottom)
            
            GeometryReader { geometry in
                ZStack {
                    // Minute Markers
                    ForEach(0..<60) { index in
                        let isQuarterMark = index % 15 == 0
                        let isFiveMark = index % 5 == 0
                        let lineWidth: CGFloat = isFiveMark ? isQuarterMark ? 10 : 5 : 2.5
                        let length: CGFloat = isFiveMark ? isQuarterMark ? 20 : 10 : 5
                        let angle = Double(index) * 6.0 // 360 degrees / 60 minutes = 6 degrees per minute
                        
                        let startX = geometry.size.width / 2 + (geometry.size.width / 2 - length) * CGFloat(cos(angle * .pi / 180))
                        let startY = geometry.size.height / 2 + (geometry.size.height / 2 - length) * CGFloat(sin(angle * .pi / 180))
                        let endX = geometry.size.width / 2 + (geometry.size.width / 2) * CGFloat(cos(angle * .pi / 180))
                        let endY = geometry.size.height / 2 + (geometry.size.height / 2) * CGFloat(sin(angle * .pi / 180))
                        
                        // Strokes
                        Path { path in
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                        .modifier(BlueGradientTextStyle())
                    }
                    
                    // Selection Hand
                    Hand(angle: totalAngle)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            onDrag(value: value, in: geometry.size)
                        })
                        .onEnded({ value in
                            let velocity = CGSize(
                                width: value.predictedEndLocation.x - value.location.x, height: value.predictedEndLocation.y - value.location.y
                            )
                            
                            // Example
                            
                            if abs(velocity.height) > 10 || abs(velocity.width) > 10 {
                                withAnimation {
                                    snapToNearest5MinuteMark()
                                }
                            } else {
                                withAnimation {
                                    snapToNearest5MinuteMark(false)
                                }
                            }
                        })
                )
                .rotationEffect(Angle(degrees: -89))
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            .frame(width: 200, height: 200)
        }
    }
    
    func onDrag(value: DragGesture.Value, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
        let radians = atan2(vector.dy, vector.dx)
        var angle = radians * 180 / .pi

        if angle < 0 {
            angle = 360 + angle
        }

        withAnimation(Animation.linear(duration: 0.15)) {
            // Calculate difference from the last angle to determine drag direction
            let previousAngle = totalAngle.truncatingRemainder(dividingBy: 360)
            var angleDiff = angle - previousAngle

            // Handle crossing the 0-degree mark
            if angleDiff > 180 {
                angleDiff -= 360
            } else if angleDiff < -180 {
                angleDiff += 360
            }

            // Update totalAngle and ensure it does not go below zero
            totalAngle = max(totalAngle + angleDiff, 0)
            progress = CGFloat(totalAngle / 360)
        }
    }

    func snapToNearest5MinuteMark(_ five: Bool = true) {
        // 30 degrees per 5 minutes
        let nearest5MinuteMark = round(totalAngle / 30) * 30
        let nearestMinuteMark = round(totalAngle / 6) * 6
        totalAngle = five ? nearest5MinuteMark : nearestMinuteMark
        progress = CGFloat(totalAngle / 360)
    }
    
    func timeString(from angle: Double) -> String {
        // Calculate total hours from angle
        let totalHours = (angle / 360) // 1 hour for one full circle
        
        // Convert total hours to hours and minutes
        let hours = Int(totalHours)
        let totalMinutes = totalHours * 60
        let minutes = Int(round(totalMinutes.truncatingRemainder(dividingBy: 60)))
        
        // Conditional formatting based on hours
        if hours > 0 {
            return String(format: "%dh %02dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
}

struct Hand: View {
    init(angle: Double) {
        self.angle = angle + 90
    }
    var angle: Double

    var body: some View {
        Capsule()
            .fill(Color.blue.gradient)
            .frame(width: 10, height: 90)
            .offset(y: -45)
            .rotationEffect(Angle(degrees: angle))
    }
}


#Preview {
    Clock()
}
