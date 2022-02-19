//
//  MartianTimeView.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import SwiftUI

struct MartianTimeView: View {
    @State var martianTime: Double =
    MartianTimeService().calcualteMartianTime(currentEarthTimeSeconds: Date().timeIntervalSince1970, longitude: 0.0)
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        Text(MartianTimeService().convertDoubleToDigialtclockTime(mct: martianTime))
            .onReceive(timer) { input in
                self.martianTime =
                MartianTimeService().calcualteMartianTime(currentEarthTimeSeconds: Date().timeIntervalSince1970, longitude: 0.0)
            }
    }
}

struct MartianTimeView_Previews: PreviewProvider {
    static var previews: some View {
        MartianTimeView()
    }
}
