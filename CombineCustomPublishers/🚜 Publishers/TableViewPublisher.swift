//
//  TableViewPublisher.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import Combine
import UIKit

enum TableValue {
    case indexPath(IndexPath)
    case offSet(CGFloat)
}

extension UITableView {
    var publisher: Publishers.TableViewPublisher {
        return Publishers.TableViewPublisher(tableView: self)
    }
}

extension Publishers {
    struct TableViewPublisher: Publisher {
        typealias Output = TableValue
        typealias Failure = Never
        
        private let tableView: UITableView
        
        init(tableView: UITableView) { self.tableView = tableView }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.TableViewPublisher.Failure == S.Failure, Publishers.TableViewPublisher.Output == S.Input {
            let subscription = TableViewSubscription(subscriber: subscriber, tableView: tableView)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class TableViewSubscription<S: Subscriber>: Subscription where S.Input == TableValue, S.Failure == Never {
        
        private var subscriber: S?
        private weak var tableView: UITableView?
        private let delegate = TableViewDelegate()
        
        init(subscriber: S, tableView: UITableView) {
            self.subscriber = subscriber
            self.tableView = tableView
            subscribe()
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
            tableView = nil
        }
        
        private func subscribe() {
            tableView?.delegate = delegate
            delegate.selected = { [weak self] indexPath in
                _ = self?.subscriber?.receive(indexPath)
            }
        }
    }
    
    class TableViewDelegate: NSObject, UITableViewDelegate {
        
        var selected: ((TableValue) -> Void)?
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selected?(.indexPath(indexPath))
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            selected?(.offSet(scrollView.contentOffset.y))
        }
    }
}
