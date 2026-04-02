//
//  PushObservableObject.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

@MainActor
public protocol PushObservableObject: ObservableObject {
    /// Вид для навигации
    var viewToPush: AnyView? { get set }
}

public extension PushObservableObject {
    func pushView<Content: View>(
        @ViewBuilder content: () -> Content
    ) {
        self.viewToPush = AnyView(content())
    }
}
