//
//  LocalKeys.swift
//  SleepKitProto
//
//  Created by 현 on 2020/06/30.
//  Copyright © 2020 현. All rights reserved.
//

import Foundation
struct LocalKeys {
    // UserDefaults Keys
    let cache: String = "SleepKit_SleepTimeCache"
    let goal: String = "SleepKit_SleepGoal"
    
    // Complication Identifiers
    let comps = ComplicationIdentifiers()
}

struct ComplicationIdentifiers {
    let pgCuSm: String = "SleepKit_ProgressCircularSmallComplication" // ProGressCircUlarSMallcomplication
}
