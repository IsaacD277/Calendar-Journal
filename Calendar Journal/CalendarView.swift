//
//  CalendarView.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedMonth: Date = .currentMonth
    @State private var selectedDate: Date = .now
    var safeArea: EdgeInsets
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            /// Converting Scroll into Progress
            let maxHeight = size.height - (calendarTitleViewHeight + weekLabelHeight + safeArea.top + 50 + topPadding + bottomPadding - 50)
            let progress = max(min((-minY / maxHeight), 1), 0)
            
            VStack(alignment: .leading, spacing: 0, content: {
                Text(currentMonth)
                    .font(.system(size: 35 - 10 * progress))
                    .fontWeight(.bold)
                    .offset(y: -50 * progress - 1)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .overlay(alignment: .topLeading, content: {
                        GeometryReader {
                            let size = $0.size
                            
                            Text(year)
                                .font(.system(size: 25 - (10 * progress)))
                                .offset(x: (size.width + 5) * progress, y: progress * 3)
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .topTrailing, content: {
                        HStack(spacing: 15) {
                            Button() {
                                withAnimation {
                                    selectedDate = .now
                                    selectedMonth = .currentMonth
                                }
                            } label: {
                                Text("Today")
                                    .foregroundStyle(.primary)
                            }
                            
                            Button("", systemImage: "chevron.left") {
                                /// Update to previous month
                                monthUpdate(false)
                                print(safeArea)
                            }
                            
                            Button("", systemImage: "chevron.right") {
                                /// Update to next month
                                monthUpdate(true)
                            }
                        }
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .offset(x: 150 * progress)
                    })
                    .frame(height: calendarTitleViewHeight)
                
                VStack(spacing: 0) {
                    /// Day Labels
                    HStack(spacing: 0) {
                        ForEach(Calendar.current.weekdaySymbols, id: \.self) { symbol in
                            Text(symbol.prefix(3))
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: weekLabelHeight)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0, content: {
                        ForEach(selectedMonthDates) { day in
                            ZStack {
                                Circle()
                                    .foregroundStyle(.blue.gradient)
                                    .frame(width: 35, height: 35) // Adjust size as needed
                                    .opacity(Calendar.current.isDate(day.date, inSameDayAs: selectedDate) ? 1 : 0)
                                Text(day.shortSymbol)
                                    .foregroundStyle(day.ignored ? .secondary : .primary)
                                    .frame(maxWidth: .infinity, alignment: .center) // Center the text
                                    .frame(height: 50)
                                    .contentShape(Rectangle()) // Ensure the entire area is tappable
                                    .onTapGesture {
                                        selectedDate = day.date
                                        
                                        monthUpdate()
                                        let nextMonth = selectedMonth
                                        monthUpdate(false)
                                        
                                        if selectedDate >= nextMonth {
                                            withAnimation {
                                                monthUpdate(true)
                                            }
                                        } else if selectedDate < selectedMonth {
                                            withAnimation {
                                                monthUpdate(false)
                                            }
                                        }
                                    }
                            }
                        }
                    })
                    .frame(height: calendarGridHeight - ((calendarGridHeight - 50) * progress), alignment: .top)
                    .offset(y: (monthProgress * -50) * progress)
                    .clipped()
                }
                .offset(y: progress * -50)
            })
            .foregroundStyle(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.top, safeArea.top)
            .padding(.bottom, bottomPadding)
            .frame(maxHeight: .infinity)
            .frame(height: size.height - (maxHeight * progress), alignment: .top)
            .background(.red.gradient)
            .clipped()
            /// Sticking it to top
            .offset(y: -minY)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 {
                            withAnimation {
                                monthUpdate(true)
                            }
                        } else if value.translation.width > 0 {
                            withAnimation {
                                monthUpdate(false)
                            }
                        }
                    }
            )
        }
        .frame(height: calendarHeight)
        .zIndex(1000)
    }
    
    /// Date Formatter
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: selectedMonth)
    }
    
    /// Month Increment/Decrement
    func monthUpdate(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: increment ? 1: -1, to: selectedMonth) else { return }
        selectedMonth = month
    }
    
    /// Selected Month Dates
    var selectedMonthDates: [Day] {
        return extractDates(selectedMonth)
    }
    
    /// Current Month String
    var currentMonth: String {
        return format("MMMM")
    }
    
    /// Selected Year
    var year: String {
        return format("YYYY")
    }
    
    var monthProgress: CGFloat {
        let calendar = Calendar.current
        if let index = selectedMonthDates.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            return CGFloat(index / 7).rounded()
        }
        
        return 1.0
    }
    
    /// View Heights
    var calendarHeight: CGFloat {
        return calendarTitleViewHeight + weekLabelHeight + calendarGridHeight + safeArea.top + topPadding + bottomPadding
    }
    
    var calendarTitleViewHeight: CGFloat {
        return 75.0
    }
    
    var weekLabelHeight: CGFloat {
        return 30.0
    }
    
    var calendarGridHeight: CGFloat {
        return CGFloat(selectedMonthDates.count / 7) * 50
    }
    
    var horizontalPadding: CGFloat {
        return 15.0
    }
    
    var topPadding: CGFloat {
        return 15.0
    }
    
    var bottomPadding: CGFloat {
        return 5.0
    }
}

#Preview {
    ContentView()
    // CalendarView(safeArea: EdgeInsets(top: 59.0, leading: 0.0, bottom: 34.0, trailing: 0.0))
}
