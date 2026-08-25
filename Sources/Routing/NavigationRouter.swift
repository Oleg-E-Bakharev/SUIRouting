//
//  NavigationRouter.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

/**
 Навигационный роутинг в добавок к базовому. Умеет класть виды в стек навигации (push).
 */
@MainActor
open class NavigationRouter: BaseRouter {
    var navigationState: NavigationState?

    public override init() {}

    public func push<V: View>( @ViewBuilder view: () -> V) {
        let viewToPush = AnyView(view())
        if navigationState?.viewToPush != nil {
            navigationState?.viewToPush = nil
            Task {
                // Смена пушей (например при открытии диплинков) должна закрыть старый пуш и открыть новый.
                // Без паузы, выбранной эмпирическим путем повторное открытие диплинков работает нестабильно.
                try? await Task.sleep(nanoseconds: 600_000_000)
                navigationState?.viewToPush = viewToPush
            }
        } else {
            navigationState?.viewToPush = viewToPush
        }
    }

    /**
     В добавок к скрытию показанного щита выталкивает из стека навигации все виды поверх этого.
     */
    override public func dismissChild() {
        super.dismissChild()
        navigationState?.viewToPush = nil
    }
}

@MainActor
class NavigationState: PushObservableObject {
    @Published var viewToPush: AnyView?
}
