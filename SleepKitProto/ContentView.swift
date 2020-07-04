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
    //@State var percent: Float = Float(0)
    
    var body: some View {
        return NavigationView {
            List {
                ListItemView(title: "HK 접근 가능 여부", value: String(sleep.avaliable))
                HStack{
                    VStack(alignment: .leading) {
                        Text("수면 시간")
                        Text(sleep.format(sleep.sleepTime ?? 0)).font(.system(size: 12.5))
                    }
                    Spacer()
                    Button(action: {
                        self.refresh()
                    }) {
                        Text("새로고침")
                    }
                }

                HStack{
                    VStack(alignment: .leading) {
                        Text("수면 목표")
                        Text(sleep.format(sleep.sleepGoal)).font(.system(size: 12.5))
                    }
                    Spacer()
                    Button(action: {
                        self.showSettingGoal.toggle()
                    }) {
                        Text("목표 설정")
                    }
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
        sleep.sleepTime = sleep.get()
        //percent = self.sleep.percent
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
