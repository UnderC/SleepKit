//
//  ComplicationController.swift
//  SleepKitProtoWatch WatchKit Extension
//
//  Created by 현 on 2020/07/02.
//  Copyright © 2020 현. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: localKeys.comps.pgCuSm, displayName: "SleepKitProto", supportedFamilies: [.graphicCircular])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(Date().addingTimeInterval(24 * 60 * 60))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: createComplicationTemplate(complication)))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let fiveMinutes = 5.0 * 60.0
        let twentyFourHours = 24.0 * 60.0 * 60.0
            
        // Create an array to hold the timeline entries.
        var entries = [CLKComplicationTimelineEntry]()
            
        // Calculate the start and end dates.
        var current = date.addingTimeInterval(fiveMinutes)
        let endDate = date.addingTimeInterval(twentyFourHours)
            
        // Create a timeline entry for every five minutes from the starting time.
        // Stop once you reach the limit or the end date.
        while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
            entries.append(createTimelineEntry(complication, date: current))
            current = current.addingTimeInterval(fiveMinutes)
        }
            
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    func createTimelineEntry(_ complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry {
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: createComplicationTemplate(complication))
    }
    
    func createComplicationTemplate(_ complication: CLKComplication) -> CLKComplicationTemplate {
        let sleep = SleepKitStruct()
        let percent = CLKSimpleTextProvider(text: String(Int(sleep.percent)))
        let unit = CLKSimpleTextProvider(text: "%")
        let gauge = CLKSimpleGaugeProvider(style: .ring,
                                           gaugeColors: [.red, .orange, .yellow, .green],
                                           gaugeColorLocations: [0, 0.4, 0.7, 1] as [NSNumber],
                                           fillFraction: min(sleep.percent / Float(100), 1))
        let result = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gauge, bottomTextProvider: unit, center: percent)
        //let result = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: percent, line2TextProvider: unit)
        return result
    }
}
