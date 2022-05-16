//
//  MartianTimeData.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/26/22.
//

import Foundation

struct MartianTime: Codable, Equatable {
    let julianDate: Double
    let julianDateTerrestrialTime: Double
    let timeOffsetFromJ200Epoch: Double
    let meanAnomaly: Double
    let angleOfFictionMeanSun: Double
    let perturbers: Double
    let trueAnomalyMinusMean: Double
    let aeroCentricSolarLongitude: Double
    let equationOfTimeDegrees: Double
    let meanSolarTimePrimeMeridian: Double
    let localMeanSolarTime: Double
    let localTrueSolarTime: Double
    let digitalClockTime: String
}
