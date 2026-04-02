//
//  FullScreenCoverPresenter.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

@MainActor
public protocol FullScreenCoverObservableObject: ObservableObject {
    var viewToFullScreenCover: AnyView? { get set }
}

public extension FullScreenCoverObservableObject {
    func coverFullScreen<Content: View>(
        @ViewBuilder content: () -> Content
    ) {
        self.viewToFullScreenCover = AnyView(content())
    }
}
