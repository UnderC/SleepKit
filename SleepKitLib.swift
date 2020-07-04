//
//  SleepKitLib.swift
//  SleepKitProto
//
//  Created by 현 on 2020/06/26.
//  Copyright © 2020 현. All rights reserved.
//

import Foundation
import HealthKit

let defaults = UserDefaults.standard
let localKeys = LocalKeys()

public class SleepKitStore: ObservableObject {
    var store: HKHealthStore? = nil
    @Published var sleepTime: Int? = nil
    @Published var sleepGoal: Int = 21600
    @Published var avaliable: Bool = false
    @Published var loaded: Bool = false
    var cache: Array<HKCategorySample> = []
    
    init () {
        self.avaliable = HKHealthStore.isHealthDataAvailable()
        if !self.avaliable { return }
        
        // Authorization
        
        let readDatas = Set<HKSampleType>(arrayLiteral: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        self.store = HKHealthStore()
        self.store?.requestAuthorization(toShare: nil, read: readDatas, completion: { (success, err) in
            if (err == nil || !success) { self.avaliable = false }
            self.avaliable = true
            self.refresh()
        })
        
        if let dataGoal = defaults.string(forKey: localKeys.goal) {
            self.sleepGoal = Int(dataGoal)!
        }
    }
    
    func refresh () {
        if !self.avaliable { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let sortDescriptor = NSSortDescriptor(key:
                                                HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor], resultsHandler: {
            (query, result, err) -> Void in
            if (err != nil) { return }
            var cache: Array<HKCategorySample> = []
            if let items = result {
                for item in items {
                    if let sample = item as? HKCategorySample {
                        cache.append(sample)
                    }
                }
            }
            
            self.cache = cache
            self.loaded = true
        })
        
        self.store?.execute(query)
    }
    
    func get (_ gap: Int = 0) -> Int? {
        if self.cache.capacity > 0 {
            var result = 0
            let today = Calendar.current.dateComponents([.day], from: Date()).day
            let todayDate = gap > today! ? (31 - gap) : (today! - gap)
            for lastest in self.cache {
                //print("\(lastest.startDate), \(lastest.endDate), \(lastest.value)")
                let lastDate = Calendar.current.dateComponents([.day], from: lastest.endDate).day
                if (lastDate != todayDate) || lastest.value == 1 {
                    continue
                }
                result += Int(lastest.endDate.timeIntervalSince(lastest.startDate))
            }
            if result != 0 { return result }
            return get(gap + 1)
        }
        return nil
    }
    
    func format (_ timeGap: Int) -> String {
        let hours = Int(timeGap / 3600)
        let minutes = Int((Int(timeGap) - (hours * 3600)) / 60)
        return "\(hours)시간 \(minutes)분"
    }
}
