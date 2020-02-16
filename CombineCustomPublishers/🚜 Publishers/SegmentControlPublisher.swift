//
//  SegmentControlPublisher.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UISegmentedControl {
    var publisher: Publishers.SegmentedControlPublisher {
        return Publishers.SegmentedControlPublisher(segmentedControl: self)
    }
}

extension Publishers {
    struct SegmentedControlPublisher: Publisher {
        typealias Output = String
        typealias Failure = Never
        
        private let segmentedControl: UISegmentedControl
        
        init(segmentedControl: UISegmentedControl) { self.segmentedControl = segmentedControl }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.SegmentedControlPublisher.Failure == S.Failure, Publishers.SegmentedControlPublisher.Output == S.Input {
            let subscription = SegmentedControlSubscription(subscriber: subscriber,
                                                            segmentedControl: segmentedControl)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class SegmentedControlSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never {
        
        private var subscriber: S?
        private weak var segmentedControl: UISegmentedControl?
        
        init(subscriber: S, segmentedControl: UISegmentedControl) {
            self.subscriber = subscriber
            self.segmentedControl = segmentedControl
            subscribe()
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() { }
        
        private func subscribe() {
            segmentedControl?.addTarget(self,
                                        action: #selector(valueChanged(_:)),
                                        for: .valueChanged)
        }
        
        @objc private func valueChanged(_ sender: UISegmentedControl) {
            _ = subscriber?.receive(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")
        }
    }
}
