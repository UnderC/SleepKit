//
//  SleepKitStruct.swift
//  SleepKitProto
//
//  Created by 현 on 2020/07/04.
//  Copyright © 2020 현. All rights reserved.
//

import Foundation

let defaults = UserDefaults(suiteName: "group.DevUC.SleepKitProto")
let localKeys = LocalKeys()

public class SleepKitStruct: ObservableObject {
    @Published var sleepTime: Int? = nil
    @Published var sleepGoal: Int = 21600
    var result: Bool {
        get { (self.sleepTime ?? 0) > self.sleepGoal }
    }
    
    public var percent: Float {
        get { /*Int*/(Float(sleepTime ?? 0) / Float(sleepGoal) * 100) }
    }
    
    init () {
        if let dataGoal = defaults!.string(forKey: localKeys.goal) {
            self.sleepGoal = Int(dataGoal)!
        }
        
        if let cache = defaults!.string(forKey: localKeys.cache) {
            self.sleepTime = Int(cache)!
        }
    }
}
