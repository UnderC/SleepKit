//
//  ContentView.swift
//  SleepKitforWatch Extension
//
//  Created by 현 on 2020/07/05.
//  Copyright © 2020 현. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sleep = SleepKitStore()
    var body: some View {
        NavigationView {
            List {
                ListItemView(title: "HK 접근 가능 여부", value: String(self.sleep.avaliable))
                Button(action: {
                    self.refresh()
                }) {
                    ListItemView(title: "수면 시간", value: self.sleep.format(self.sleep.sleepTime))
                }
                ListItemView(title: "수면 목표", value: self.sleep.format(self.sleep.sleepGoal))
                ListItemView(title: "달성률", value: "\(Int(sleep.percent)) %")
                ListItemView(title: "달성 여부", value: String(sleep.result))
            }.navigationTitle("SleepKit")
        }.onAppear() {
            self.sleep.sleepTime = self.sleep.get()
        }
    }
    
    func refresh () {
        self.sleep.refresh()
        sleep.sleepTime = sleep.get()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
