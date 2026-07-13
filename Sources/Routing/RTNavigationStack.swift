//
//  RTNavigationStack.swift
//  SUIRouting
//
//  Created by Олег Бахарев on 13.07.2026.
//  Copyright (c) 2026 M.Tex. All rights reserved.
//

import SwiftUI

/// NavigationStack который под iOS 15 использует NavigationStackBackport и реализует функционал dismiss под iOS15 (чего не обеспечивает NavigationStackBackport)
/// - note: Чтобы на iOS15 работали dismiss надо использовать вместе с RTNavigationStack @environment(\.rtDismiss) var dismiss
public struct RTNavigationStack<Content: View>: View {
    let content: Content

    @Environment(\.dismiss) private var dismiss

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @ViewBuilder
    public var body: some View {
        NavigationStack {
            content
        }
        .environment(\.customDismiss, dismiss)
    }
}

@MainActor
public protocol CustomDissmissal {
    @preconcurrency func callAsFunction()
}

extension DismissAction : CustomDissmissal {}

public extension EnvironmentValues {
    @Entry var customDismiss: CustomDissmissal?
    
    /// Для того чтобы закрытие работало на iOS15 c NavigationStack Backport. Внутри View.body
    /// - note: Надо использовть RTNavigationStack и @environment(\.rtDismiss) var dismiss
    var rtDismiss: CustomDissmissal { customDismiss ?? dismiss }
}
