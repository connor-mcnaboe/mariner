//
//  AppState.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/26/22.
//

import Foundation
import Combine

struct AppState: Equatable {
    var system = System()
    var martianData = MartianData()
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}

extension AppState {
    struct MartianData: Equatable {
        var martianData = MartianTime(julianDate: 0.0,
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
                                              digitalClockTime: "00:00:00")
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.martianData == rhs.martianData &&
        lhs.system == rhs.system
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        state.martianData.martianData = MartianTime(julianDate: 0.0,
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
                                                        digitalClockTime: "00:00:00")
        return state
    }
}
#endif

