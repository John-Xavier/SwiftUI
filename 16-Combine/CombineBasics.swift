//
//  CombineBasics.swift
//  Publishers, operators, sink, @Published, and cancellables.
//

import SwiftUI
import Combine

final class CombineBasics: ObservableObject {

    // @Published creates a publisher: `$count` emits every time `count` changes.
    @Published var count = 0
    @Published private(set) var label = "Count is 0"

    // You MUST hold onto subscriptions or they're cancelled instantly.
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Pipeline: whenever count changes → transform → assign to `label`.
        $count
            .map { "Count is \($0)" }               // operator: transform each value
            .receive(on: DispatchQueue.main)         // deliver on main thread (UI-safe)
            .assign(to: &$label)                     // assign directly to another @Published

        // A `sink` subscriber runs a closure for each emitted value.
        $count
            .filter { $0 % 2 == 0 }                  // only even numbers pass
            .sink { even in
                print("Even count: \(even)")
            }
            .store(in: &cancellables)                // retain the subscription
    }

    // Combining multiple publishers:
    func demoCombineLatest(a: AnyPublisher<Int, Never>, b: AnyPublisher<Int, Never>) {
        a.combineLatest(b)                           // emits when EITHER changes
            .map { $0 + $1 }
            .sink { print("Sum: \($0)") }
            .store(in: &cancellables)
    }
}
