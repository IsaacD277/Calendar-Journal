//
//  CardView.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//
// Test Card View (For Scroll Content)

import SwiftUI

struct CardView: View {
    let day: Day
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.blue.gradient)
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                        Text(day.shortSymbol)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(day.weekDayName)")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                    }
                }
                .foregroundStyle(.white.opacity(0.25))
                .padding(15)
            }
    }
}

#Preview {
    var day = Day.dummy
    day.ignored = false
    return CardView(day: day)
}
