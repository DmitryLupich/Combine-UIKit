//
//  SwitchPublisher.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UISwitch {
    var publisher: Publishers.SwitchPublisher {
        return Publishers.SwitchPublisher(switcher: self)
    }
}

extension Publishers {
    struct SwitchPublisher: Publisher {
        typealias Output = Bool
        typealias Failure = Never
        
        private let switcher: UISwitch
        
        init(switcher: UISwitch) { self.switcher = switcher }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.SwitchPublisher.Failure == S.Failure, Publishers.SwitchPublisher.Output == S.Input {
            let subscription = SwitchSubscription(subscriber: subscriber, switcher: switcher)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class SwitchSubscription<S: Subscriber>: Subscription where S.Input == Bool, S.Failure == Never {
        
        private var subscriber: S?
        private weak var switcher: UISwitch?
        
        init(subscriber: S, switcher: UISwitch) {
            self.subscriber = subscriber
            self.switcher = switcher
            subscribe()
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
            switcher = nil
        }
        
        private func subscribe() {
            switcher?.addTarget(self,
                                action: #selector(tap(_:)),
                                for: .valueChanged)
        }
        
        @objc private func tap(_ sender: UISwitch) {
            _ = subscriber?.receive(sender.isOn)
        }
    }
}
