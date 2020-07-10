//
//  ContentView.swift
//  SleepKitProto
//
//  Created by 현 on 2020/06/26.
//  Copyright © 2020 현. All rights reserved.
//

import HealthKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sleep: SleepKitStore
    @State var loadTaskQueue: DispatchQueue? = nil
    @State var showSettingGoal = false
    
    var body: some View {
        return NavigationView {
            List {
                ListItemView(title: "HK 접근 가능 여부", value: String(sleep.avaliable))

                Button(action: {
                    self.refresh()
                }) {
                    ListItemView(title: "수면 시간", value: "새로고침", opts: sleep.format(sleep.sleepTime))
                }

                Button(action: {
                    self.showSettingGoal.toggle()
                }) {
                    ListItemView(title: "수면 목표", value: "\(Int(sleep.sleepGoal)) %")
                }
                
                ListItemView(title: "달성률", value: "\(Int(sleep.percent)) %")
                ListItemView(title: "달성 여부", value: String(sleep.result))
            }.navigationBarTitle(Text("SleepKit"))
        }.onAppear {
            self.refresh()
        }.sheet(isPresented: self.$showSettingGoal) {
            ProgressView(progress: sleep.percent).frame(width: 150, height: 150, alignment: .center)
        }
    }
    
    func refresh () {
        sleep.refresh()
        sleep.sleepTime = sleep.get()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
