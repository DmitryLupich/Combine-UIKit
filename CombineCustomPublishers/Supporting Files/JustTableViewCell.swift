//
//  JustTableViewCell.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import UIKit

class JustTableViewCell: UITableViewCell {
    override var reuseIdentifier: String? {
        return "JustTableViewCell"
    }
}

extension JustTableViewCell {
    func configure(with title: String) {
        self.textLabel?.text = title
        self.backgroundColor = .clear
    }
}
