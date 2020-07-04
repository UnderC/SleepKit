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
    @EnvironmentObject var s: SleepKitStore
    @State var loadTaskQueue: DispatchQueue? = nil
    @State var showSettingGoal = false
    @State var progress = Float(0)
    
    var body: some View {
        return NavigationView {
            List {
                HStack{
                    VStack(alignment: .leading) {
                        Text("HealthStore에 접근이 가능한가?")
                    }
                    Spacer()
                    Text(String(s.avaliable))
                }
                
                HStack{
                    VStack(alignment: .leading) {
                        Text("어제 숙면한 시간")
                        Text(s.format(self.s.sleepTime ?? 0)).font(.system(size: 12.5))
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
                        Text("너의 목표")
                        Text(s.format(self.s.sleepGoal)).font(.system(size: 12.5))
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("목표 설정")
                    }
                }
                
                HStack{
                    VStack(alignment: .leading) {
                        Text("달성도")
                    }
                    Spacer()
                    Button(action: {
                        self.showSettingGoal.toggle()
                    }) {
                        Text("\(Int(progress * 100)) %")
                    }
                }
            
                HStack{
                    VStack(alignment: .leading) {
                        Text("달성 했니?")
                    }
                    Spacer()
                    Text(String(self.s.sleepGoal < self.s.sleepTime ?? 0))
                }
            }.navigationBarTitle(Text("SleepKit"))
        }.onAppear {
            self.refresh()
        }.sheet(isPresented: self.$showSettingGoal) {
            ProgressView(progress: self.$progress).frame(width: 150, height: 150, alignment: .center)
        }
    }
    
    func refresh () {
        self.s.sleepTime = self.s.get()
        self.progress = Float(self.s.sleepTime ?? 0) / Float(self.s.sleepGoal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
