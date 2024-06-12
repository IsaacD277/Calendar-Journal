//
//  CustomScrollBehavior.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//

import SwiftUI

struct CustomScrollBehavior: ScrollTargetBehavior {
    var maxHeight: CGFloat
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < maxHeight {
            target.rect = .zero
        }
    }
}
