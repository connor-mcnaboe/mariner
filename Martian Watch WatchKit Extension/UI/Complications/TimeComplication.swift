//
//  TimeComplication.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 3/5/22.
//

import SwiftUI
import ClockKit
struct TimeComplication: View {
    
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        
    }
}

struct TimeComplication_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          CLKComplicationTemplateGraphicCircularView(
            TimeComplication()
          ).previewContext()
        }
    }
}
