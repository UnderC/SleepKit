//
//  ProgressView.swift
//  SleepKitProto
//
//  Created by 현 on 2020/07/01.
//  Copyright © 2020 현. All rights reserved.
//

// https://www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/

import Foundation
import SwiftUI

struct ProgressView: View {
    @Binding var progress: Float
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.5)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0, to: CGFloat(self.progress))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear)
            
            Text("\(Int(progress * 100))")
                .font(.largeTitle)
                .bold()
        }
    }
}
