//
//  RoutingView.swift
//  Routing
//
//  Created by Oleg Bakharev on 27.12.2025.
//

import SwiftUI

public extension View {
    /**
     Базовая маршрутизация без навигации. Используется если снаружи нет NavigationStack.
     Например, в случае исапользования TabView
     */
    func rtBaseRouting(with router: BaseRouter) -> some View {
        modifier(BaseRoutingViewModifier(router))
    }

    /**
     Базовая маршрутизация с навигацией. Используется если снаружи есть NavigationStack.
     */
    func rtNavigationRouting(with router: NavigationRouter) -> some View {
        modifier(NavigationRoutingViewModifier(router))
    }
}

private struct BaseRoutingViewModifier: ViewModifier {

    @StateObject private var routingState: RoutingState
    private let router: BaseRouter
    @Environment(\.dismiss) private var dismiss

    public init(_ router: BaseRouter) {
        _routingState = .init(wrappedValue: RoutingState())
        self.router = router
    }

    func body(content: Content) -> some View {
        content
            .rtSheet(viewState: routingState)
            .rtFullScreenCover(viewState: routingState)
            .onAppear {
                router.routingState = routingState
                routingState.dismiss = dismiss
            }
    }
}

/**
 Навигацию вынесли в отдельный модификатор чтобы исключить использование navigationDestination без NavigationStack.
 Иначе в отладочную консоль будут прилетать красные сообщения.
 */
struct NavigationRoutingViewModifier: ViewModifier {

    @StateObject private var navigationState: NavigationState
    private let router: NavigationRouter

    public init(_ router: NavigationRouter) {
        _navigationState = .init(wrappedValue: NavigationState())
        self.router = router
    }

    func body(content: Content) -> some View {
        content
            .rtPush(viewState: navigationState)
            .rtBaseRouting(with: router)
            .onAppear() {
                router.navigationState = navigationState
            }
    }
}

#if DEBUG

private struct Sample: View {

    let router = NavigationRouter()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Push") {
                    router.push {
                        VStack(spacing: 20) {
                            Text("Details")
                            Button("Back") {
                                router.dismissChild()
                            }
                        }
                        .navigationTitle("Details")
                    }
                }

                Button("Sheet") {
                    router.sheet {
                        Button("Close") {
                            router.dismissChild()
                        }
                    }
                }

                Button("Cover") {
                    router.fullScreenCover {
                        Button("Close") {
                            router.dismissChild()
                        }
                    }
                }
            }
            .navigationTitle("Master")
            .rtNavigationRouting(with: router)
        }
    }
}

#Preview {
    Sample()
}

#endif
