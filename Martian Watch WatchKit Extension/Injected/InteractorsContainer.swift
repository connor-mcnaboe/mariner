//
//  InteractorsContainer.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/26/22.
//

import Foundation

extension DIContainer {
    struct Interactors {
        let martianTimeInteractor: MartianTimeInteractor
        
        init(martianTimeInteractor: MartianTimeInteractor) {
            self.martianTimeInteractor = martianTimeInteractor
        }
        
        static var stub: Self {
            .init(martianTimeInteractor: StubMartianTimerInteractor())
        }
    }
}
