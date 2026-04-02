//
//  PushViewModifier.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

extension View {
    func rtPush<ViewState: PushObservableObject>(viewState: ViewState) -> some View {
        modifier(PushViewModifier(viewState: viewState))
    }
}

private struct PushViewModifier<ViewState: PushObservableObject>: ViewModifier {
    @StateObject var viewState: ViewState

    init(viewState: ViewState) {
        _viewState = .init(wrappedValue: viewState)
    }

    func body(content: Content) -> some View {
        content.backport.navigationDestination(
            isPresented: Binding(
                get: { viewState.viewToPush != nil },
                set: { value in
                    viewState.viewToPush = value ? viewState.viewToPush : nil
                }
            ), destination: {
                viewState.viewToPush
            }
        )
    }
}

#if DEBUG

// MARK: - Preview

private struct Sample: View {
    final class PushViewState: PushObservableObject {
        @Published var viewToPush: AnyView?
    }

    @StateObject private var viewState: PushViewState

    init() {
        _viewState = .init(wrappedValue: PushViewState())
    }

    var body: some View {
        NavigationStack {
            Button("Push text") {
                viewState.viewToPush = AnyView(
                    Button("Dismiss") {
                        viewState.viewToPush = nil
                    }
                        .navigationTitle("Detail")
                )
            }
            .rtPush(viewState: viewState)
            .navigationTitle("Master")
        }
    }
}

#Preview {
    Sample()
}

#endif
