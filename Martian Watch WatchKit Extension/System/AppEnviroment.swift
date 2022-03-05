//
//  AppEnviroment.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/26/22.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let interactors = DIContainer.Interactors.init(martianTimeInteractor: RealMartianTimeInteractor(appState: appState))
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(container: diContainer)
    }
}
