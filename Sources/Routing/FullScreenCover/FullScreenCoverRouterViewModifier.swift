//
//  FullScreenCoverRouterViewModifier.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

struct FullScreenCoverRouterViewModifier<ViewState: FullScreenCoverObservableObject>: ViewModifier {
    @StateObject private var viewState: ViewState

    public init(viewState: @autoclosure @escaping () -> ViewState) {
        _viewState = .init(wrappedValue: viewState())
    }

    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                isPresented: Binding(
                    get: { viewState.viewToFullScreenCover != nil },
                    set: { value in viewState.viewToFullScreenCover = value ? viewState.viewToFullScreenCover : nil }
                )
            ) {
                viewState.viewToFullScreenCover
            }
    }
}

extension View {
    func rtFullScreenCover<ViewState: FullScreenCoverObservableObject>(viewState: ViewState) -> some View {
        modifier(FullScreenCoverRouterViewModifier(viewState: viewState))
    }
}

#if DEBUG

// MARK: - Sample

private struct Sample: View {

    final class FullScreenCoverViewState: FullScreenCoverObservableObject {
        @Published var viewToFullScreenCover: AnyView?
    }

    @StateObject private var viewState: FullScreenCoverViewState

    init() {
        _viewState = .init(wrappedValue: FullScreenCoverViewState())
    }

    var body: some View {
        // Имитация родительского вида
        Button("Present") {
            // Имитация действия в конкретном презентере.
            viewState.coverFullScreen {
                Button("Close") {
                    self.viewState.viewToFullScreenCover = nil
                }
            }
        }
        .rtFullScreenCover(viewState: viewState) // Покажет щит когда в presenter.sheet (showSheet) установят значение
    }
}

#Preview {
    Sample()
}

#endif
