//
//  MartianTimeService.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import Foundation
import Combine

protocol MartianTimeInteractor {
    func calcualteMartianTime(currentEarthTimeSeconds: Double, longitude: Double)
    func convertDoubleToDigialtclockTime(mct: Double) -> String
}

class RealMartianTimeInteractor: MartianTimeInteractor {
    let JULIAN_DATE_OFFSET: Double = 2440587.5
    let MILLISECONDS_PER_DAY: Double = 8.64*pow(10, 7)
    let SECONDS_PER_DAY: Double = 86400.00
    let J2000_TIME_OFFSET_SECONDS: Double = 2451545.0
    
    let PERTURBERS_MAGNITUDE: Array<Double> = [0.0071, 0.0057, 0.0039, 0.0037, 0.0021, 0.0020, 0.0018]
    let PERTURBERS_PERIOD: Array<Double> = [2.2353, 2.7543, 1.1177, 15.7866, 2.1354, 2.4694, 32.8493]
    let PERTURBERS_PHASE: Array<Double> = [49.409, 168.173, 191.837, 21.736, 15.704, 95.528, 49.095]
    
    let appState: Store<AppState>
    
    var cancellable: Cancellable?
    
    init(appState: Store<AppState>) {
        self.appState = appState
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .print("test")
            .sink(receiveValue: { _ in
                self.calcualteMartianTime(currentEarthTimeSeconds: Date().timeIntervalSince1970, longitude: 0.0)
            })
    }
    
    
    public func calcualteMartianTime(currentEarthTimeSeconds: Double, longitude: Double) {
        let currentEarthTimeMillis = currentEarthTimeSeconds*1000
        
        // Convert UTC to Julian Date
        let julianDate: Double = JULIAN_DATE_OFFSET + (currentEarthTimeMillis/MILLISECONDS_PER_DAY)
        
        // Determine UTC to Terrestial Time (TT) Conversion:
        let terrestrialTimeUTCOffset: Double = 64.184
        
        // Determine Julian Date:
        let julianDateTerrestrialTime: Double = julianDate + terrestrialTimeUTCOffset/SECONDS_PER_DAY
        
        // Determine Time OffSet
        let timeOffsetFromJ200Epoch: Double = julianDateTerrestrialTime - J2000_TIME_OFFSET_SECONDS
        
        // Martian Mean Anomaly:
        let meanAnomaly: Double = 19.3871 + 0.52402073*timeOffsetFromJ200Epoch
        
        // Angle of Fiction Mean Sun:
        let angleOfFictionMeanSun: Double = 270.3871 + 0.524038496*timeOffsetFromJ200Epoch
        
        // Determine perturburs:
        var perturbers: Double = 0.0
        
        for i in 0..<PERTURBERS_MAGNITUDE.count {
            perturbers = perturbers + PERTURBERS_MAGNITUDE[i]*cosDeg(deg: 0.985626*timeOffsetFromJ200Epoch/PERTURBERS_PERIOD[i] + PERTURBERS_PHASE[i])
        }
        
        // Equation of center:
        let trueAnomalyMinusMean: Double = (10.691 + 3*pow(10, -7)*timeOffsetFromJ200Epoch)*sinDeg(deg: meanAnomaly) + 0.623*sinDeg(deg: 2*meanAnomaly)
        + 0.050*sinDeg(deg: 3*meanAnomaly) + 0.005*sinDeg(deg: 4*meanAnomaly) + 0.0005*sinDeg(deg: 5*meanAnomaly) + perturbers
        
        // Determine areocentric solar longitude:
        let aeroCentricSolarLongitude: Double = angleOfFictionMeanSun + trueAnomalyMinusMean
        
        // Determine equation of time:
        let equationOfTimeDegrees: Double = 2.861*sinDeg(deg: 2*aeroCentricSolarLongitude) - 0.071*sinDeg(deg: 4*aeroCentricSolarLongitude) + 0.002*sinDeg(deg: 6*aeroCentricSolarLongitude) - trueAnomalyMinusMean
        
        // Determine Mean Solar Time at Mars's prime meridian, i.e., Airy Mean Time.
        let meanSolarTimePrimeMeridian: Double = (24*(((julianDateTerrestrialTime - 2451549.5) / 1.0274912517) + 44796.0 - 0.0009626 )).truncatingRemainder(dividingBy: 24.0)
        
        // Determine the Local Mean Solar Time:
        let localMeanSolarTime: Double = (meanSolarTimePrimeMeridian - longitude*(24/360)).truncatingRemainder(dividingBy: 24.00)
        
        
        // Detemine the local true solar time:
        let localTrueSolarTime: Double = Double(localMeanSolarTime) + equationOfTimeDegrees*(24/360)
        
        let digitalClockTime = convertDoubleToDigialtclockTime(mct: localMeanSolarTime)
        
        let martianTimeData = MartianTimeData(julianDate: julianDate,
                                              julianDateTerrestrialTime: julianDateTerrestrialTime,
                                              timeOffsetFromJ200Epoch: timeOffsetFromJ200Epoch,
                                              meanAnomaly: meanAnomaly,
                                              angleOfFictionMeanSun: angleOfFictionMeanSun,
                                              perturbers: perturbers,
                                              trueAnomalyMinusMean: trueAnomalyMinusMean,
                                              aeroCentricSolarLongitude: aeroCentricSolarLongitude,
                                              equationOfTimeDegrees: equationOfTimeDegrees,
                                              meanSolarTimePrimeMeridian: meanSolarTimePrimeMeridian,
                                              localMeanSolarTime: localMeanSolarTime,
                                              localTrueSolarTime: localTrueSolarTime,
                                              digitalClockTime: digitalClockTime)
        
        appState.value.martianData.martianData = martianTimeData
    }
    
    public func convertDoubleToDigialtclockTime(mct: Double) -> String {
        let hours: Double = floor(mct)
        let minutes: Double = floor((mct - hours)*60)
        let seconds: Double = floor(((mct - hours)*60 - minutes)*60)
        
        let hourString: String = convertTimeDoubleToString(timeDouble: hours)
        let minuteString: String = convertTimeDoubleToString(timeDouble: minutes)
        let secondString: String = convertTimeDoubleToString(timeDouble: seconds)
        
        return hourString + ":" + minuteString + ":" + secondString
    }
    
    internal func convertTimeDoubleToString(timeDouble: Double) -> String {
        if timeDouble != 0.0 {
            if (timeDouble < 10.0) {
                return "0" + String(Int(timeDouble))
            } else {
                return String(Int(timeDouble))
            }
        } else {
            return "00"
        }
    }
    
    internal func sinDeg(deg: Double) -> Double {
        return sin(deg*Double.pi/180.00)
    }
    
    internal func cosDeg(deg: Double) -> Double {
        return cos(deg*Double.pi/180.00)
    }
}

struct StubMartianTimerInteractor: MartianTimeInteractor {
    func calcualteMartianTime(currentEarthTimeSeconds: Double, longitude: Double) { }
    func convertDoubleToDigialtclockTime(mct: Double) -> String { return "00:00:00" }
}
