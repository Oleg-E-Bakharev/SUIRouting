//
//  BaseRouter.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

/**
 Базовый роутинг. Показывает щиты(sheet) и покрытия(fullScreenCover).
 Также умеет срывать себя или то что показано, если оно есть.
 */
@MainActor
open class BaseRouter {
    var routingState: RoutingState?

    public init() {}

    public func sheet<V: View>(view: () -> V) {
        routingState?.viewToSheet = AnyView(view())
    }

    public func fullScreenCover<V: View>(view: () -> V) {
        routingState?.viewToFullScreenCover = AnyView(view())
    }

    /**
     Выталкивавает вид из стека навигации* или скрывает щит.

     *Работает только если этот вид видим на экране
     Если экран не верхний в стеке навигации, то метод работать не будет.
     В этом случае надо вызывать dismissChild нижнего в стеке навигации вида.
     */
    public func dismissSelf() {
        routingState?.dismiss?()
    }

     /// Скрывает показываемый из данного вид, если он есть.
    public func dismissChild() {
        routingState?.viewToSheet = nil
        routingState?.viewToFullScreenCover = nil
    }
}

@MainActor
class RoutingState: SheetObservableObject, FullScreenCoverObservableObject {
    @Published var dismiss: DismissAction?
    @Published var viewToSheet: AnyView?
    @Published var viewToFullScreenCover: AnyView?
}
