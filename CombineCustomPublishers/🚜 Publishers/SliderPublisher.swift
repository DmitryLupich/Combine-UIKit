//
//  SliderPublisher.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UISlider {
    var publisher: Publishers.SliderPublisher {
        return Publishers.SliderPublisher(slider: self)
    }
}

extension Publishers {
    struct SliderPublisher: Publisher {
        typealias Output = CGFloat
        typealias Failure = Never

        private let slider: UISlider

        init(slider: UISlider) { self.slider = slider }

        func receive<S>(subscriber: S) where S : Subscriber, Publishers.SliderPublisher.Failure == S.Failure, Publishers.SliderPublisher.Output == S.Input {
            let subscription = SliderSubscription(subscriber: subscriber, slider: slider)
            subscriber.receive(subscription: subscription)
        }
    }

    class SliderSubscription<S: Subscriber>: Subscription where S.Input == CGFloat, S.Failure == Never {

        private var subscriber: S?
        private weak var slider: UISlider?

        init(subscriber: S, slider: UISlider) {
            self.subscriber = subscriber
            self.slider = slider
            subscribe()
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() { }

        private func subscribe() {
            slider?.addTarget(self,
                              action: #selector(valueChanged(_:)),
                              for: .valueChanged)
        }

        @objc private func valueChanged(_ sender: UISlider) {
            _ = subscriber?.receive(CGFloat(sender.value))
        }
    }
}
