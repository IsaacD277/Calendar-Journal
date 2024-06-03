//
//  CardView.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//
// Test Card View (For Scroll Content)

import SwiftUI

struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.blue.gradient)
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12) {
                    Circle()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 100, height: 5)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                    })
                }
                .foregroundStyle(.white.opacity(0.25))
                .padding(15)
            }
    }
}

#Preview {
    CardView()
}
