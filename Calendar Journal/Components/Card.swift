//
//  Card.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//
//  Test Card View (For Scroll Content)

import SwiftUI

struct Card: View {
    let day: Day
    var isPast: Bool
    @State private var showingAddNotesView: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(isPast ? Color.blue.gradient.opacity(0.60) : Color.blue.gradient.opacity(1.0))
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                        Text(day.shortSymbol)
                            .fontWeight(.bold)
                            .foregroundStyle(isPast ? Color.white.opacity(0.55) : Color.white.opacity(0.85))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(day.weekDayName)")
                            .fontWeight(.bold)
                            .foregroundStyle(isPast ? Color.white.opacity(0.55) : Color.white.opacity(0.85))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddNotesView.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .frame(height: 40)
                        .padding(.horizontal)
                        .fontWeight(.bold)
                        .foregroundStyle(isPast ? Color.white.opacity(0.55) : Color.white.opacity(0.85))
                        .background(content: {
                            Capsule()
                        })
                    })
                }
                .foregroundStyle(isPast ? Color.white.opacity(0.25) :  Color.white.opacity(0.35))
                .padding(15)
            }
            .sheet(isPresented: $showingAddNotesView) {
                AddNotesView()
            }
    }
    
    init(day: Day) {
        self.day = day
        self.isPast = day.date < Calendar.current.startOfDay(for: Date.now)
    }
}

#Preview {
    var day = Day.dummy
    day.ignored = false
    return Card(day: day)
}
