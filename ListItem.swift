//
//  ListItem.swift
//  SleepKitProto
//
//  Created by 현 on 2020/07/04.
//  Copyright © 2020 현. All rights reserved.
//

import Foundation
import SwiftUI

struct ListItemView: View {
    var title: String
    var value: String
    var opts: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.title)
                if self.opts != nil { Text(self.opts!).font(.caption) }
            }
            Spacer()
            Text(self.value)
        }
    }
}
