//
//  MartianTimeView.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import SwiftUI

struct MartianTimeView: View {
    let marsColor = Color(red: 237/255, green: 76/255, blue: 42/255)
    @State var martianTime: Double =
    MartianTimeService().calcualteMartianTime(currentEarthTimeSeconds: Date().timeIntervalSince1970, longitude: 0.0)
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .fill(marsColor)
                .scaledToFit()
            
            VStack {
                Text("Mars Time").font(.subheadline)
                
                Text(MartianTimeService().convertDoubleToDigialtclockTime(mct: martianTime))
                    .onReceive(timer) { input in
                        self.martianTime =
                        MartianTimeService().calcualteMartianTime(currentEarthTimeSeconds: Date().timeIntervalSince1970, longitude: 0.0)
                    }.font(.title)
                    .padding()
            }
        }
    }
    
    struct MartianTimeView_Previews: PreviewProvider {
        static var previews: some View {
            MartianTimeView()
        }
    }
}
