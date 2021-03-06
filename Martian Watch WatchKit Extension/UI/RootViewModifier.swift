//
//  RootViewModifier.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/26/22.
//

import SwiftUI
import Combine

struct RootViewAppearance: ViewModifier {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false
    internal let inspection = Inspection<Self>()
    
    func body(content: Content) -> some View {
        content
            .onReceive(stateUpdate) { self.isActive = $0 }
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var stateUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.system.isActive)
    }
}
