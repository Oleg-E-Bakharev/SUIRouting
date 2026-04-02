//
//  SheetRouterView.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

extension View {
    func rtSheet<ViewState: SheetObservableObject>(viewState: ViewState) -> some View {
        modifier(SheetRouterViewModifier(viewState: viewState))
    }
}

private struct SheetRouterViewModifier<ViewState: SheetObservableObject>: ViewModifier {
    @StateObject private var viewState: ViewState

    public init(viewState: @autoclosure @escaping () -> ViewState) {
        _viewState = .init(wrappedValue: viewState())
    }

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: Binding(
                    get: { viewState.viewToSheet != nil },
                    set: { value in viewState.viewToSheet = value ? viewState.viewToSheet : nil }
                )
            ) {
                viewState.viewToSheet
            }
    }
}

#if DEBUG

// MARK: - Sample

private struct Sample: View {

    final class SheetState: SheetObservableObject {
        @Published var viewToSheet: AnyView?
    }

    @StateObject private var viewState: SheetState

    init() {
        _viewState = .init(wrappedValue: SheetState())
    }

    var body: some View {
        // Имитация родительского вида
        Button("Present") {
            // Имитация действия в конкретном презентере.
            viewState.displaySheet {
                Button("Close") {
                    self.viewState.viewToSheet = nil
                }
            }
        }
        .rtSheet(viewState: viewState) // Покажет щит когда в presenter.sheet (showSheet) установят значение
    }
}

#Preview {
    Sample()
}

#endif
