//
//  Home.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 5/30/24.
//

import SwiftUI

struct Home: View {
    // View Properties
    var safeArea: EdgeInsets
    var body: some View {
        let maxHeight = CalendarView(safeArea: safeArea).calendarHeight - (CalendarView(safeArea: safeArea).calendarTitleViewHeight + CalendarView(safeArea: safeArea).weekLabelHeight + CalendarView(safeArea: safeArea).safeArea.top + 50 + CalendarView(safeArea: safeArea).topPadding + CalendarView(safeArea: safeArea).bottomPadding - 50)
        
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                CalendarView(safeArea: safeArea)
                
                VStack(spacing: 15) {
                    ForEach(extractDates(.currentMonth), id: \.self) { day in
                        CardView(day: day) // NOT REAL
                    }
                }
                .padding(15)
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(CustomScrollBehavior(maxHeight: maxHeight))
    }
}

#Preview {
    ContentView()
}
