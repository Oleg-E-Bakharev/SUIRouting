//
//  SheetObservableObject.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

@MainActor
public protocol SheetObservableObject: ObservableObject {
    /// Управляет показом/скрытием щита.
    var viewToSheet: AnyView? { get set }
}

public extension SheetObservableObject {
    /// Показать щит.
    func displaySheet<Content: View>(@ViewBuilder content: () -> Content) {
        self.viewToSheet = AnyView(content())
    }
}
