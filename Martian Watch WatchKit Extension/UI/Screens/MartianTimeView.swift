//
//  MartianTimeView.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import SwiftUI
import Combine

struct MartianTimeView: View {
    let marsColor = Color(red: 237/255, green: 76/255, blue: 42/255)
    @Environment(\.injected) private var injected: DIContainer
    @State private var state = ViewState()
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            Circle()
                .fill(marsColor)
                .scaledToFit()
            
            VStack {
                Text("Mars Time").font(.subheadline)
                
                Text("\(state.currentMartianData.digitalClockTime)")
                    .onReceive(stateUpdate) { self.state = $0 }
                    .font(.title)
                    .padding()
            }
        }
    }
    
    private var stateUpdate: AnyPublisher<ViewState, Never> {
        injected.appState.map{$0.viewState}
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    struct MartianTimeView_Previews: PreviewProvider {
        static var previews: some View {
            MartianTimeView()
        }
    }
}

// Local View State Mapping container:
private extension MartianTimeView {
    struct ViewState: Equatable {
        var currentMartianData: MartianTime = MartianTime(julianDate: 0.0,
                                                                  julianDateTerrestrialTime: 0.0,
                                                                  timeOffsetFromJ200Epoch: 0.0,
                                                                  meanAnomaly: 0.0,
                                                                  angleOfFictionMeanSun: 0.0,
                                                                  perturbers: 0.0,
                                                                  trueAnomalyMinusMean: 0.0,
                                                                  aeroCentricSolarLongitude: 0.0,
                                                                  equationOfTimeDegrees: 0.0,
                                                                  meanSolarTimePrimeMeridian: 0.0,
                                                                  localMeanSolarTime: 0.0,
                                                                  localTrueSolarTime: 0.0,
                                                                  digitalClockTime: "--:--:--")
    }
}

// Mapping from AppState to local View State
private extension AppState {
    var viewState: MartianTimeView.ViewState {
        return .init(currentMartianData: martianData.martianData)
    }
}
