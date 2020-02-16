//
//  ViewController.swift
//  CombineCustomPublishers
//
//  Created by Dmitriy Lupych on 14.02.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet private weak var outputLabel: UILabel!
    @IBOutlet private weak var justButton: UIButton!
    @IBOutlet private weak var justTextField: UITextField!
    @IBOutlet private weak var justSlider: UISlider!
    @IBOutlet private weak var justSegmentControl: UISegmentedControl!
    @IBOutlet private weak var justSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var spinnerButton: UIButton!
    @IBOutlet private weak var justSwitch: UISwitch!
    @IBOutlet private weak var justTableView: UITableView!
    
    private var cancelBag = Set<AnyCancellable>()
    private let cellModels = Array(0...99).map(String.init)
    private let cellID = "JustTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStreams()
    }
}

extension ViewController {
    private func setupView() {
        setupTableView()
    }
    
    private func setupStreams() {
        let justTap = justButton.publisher.share()
        
        justTap
            .map { "Button tap".consoleLog("🆗") }
            .assign(to: \UILabel.text, on: outputLabel)
            .store(in: &cancelBag)
        
        justTap.sink { _ in
            self.view.endEditing(true)
        }.store(in: &cancelBag)
        
        justTextField.publisher
            .map { $0.consoleLog("🔠") }
            .assign(to: \UILabel.text, on: outputLabel)
            .store(in: &cancelBag)
        
        justSlider.publisher
            .map { String(describing: $0).consoleLog("↔️") }
            .assign(to: \UILabel.text, on: outputLabel)
            .store(in: &cancelBag)
        
        justSegmentControl.publisher
            .map { $0.consoleLog("🔢") }
            .assign(to: \UILabel.text, on: outputLabel)
            .store(in: &cancelBag)
        
        spinnerButton.publisher
            .scan(false) { (flag, _) -> Bool in
                return !flag
        }.sink(receiveValue: { flag in
            flag ? self.justSpinner.startAnimating() : self.justSpinner.stopAnimating()
            self.outputLabel.text = flag ? "▶️ Run Spinner" : "⏸ Stop Spinner"
        }).store(in: &cancelBag)
        
        justSwitch.publisher
            .sink(receiveValue: { isOn in
                self.outputLabel.text = isOn ? "1️⃣ Switch is On" : "0️⃣ Switch is Off"
            }).store(in: &cancelBag)
        
        justTableView.publisher
            .map(mapToSrting(_:))
            .assign(to: \UILabel.text, on: outputLabel)
            .store(in: &cancelBag)
    }
    
    private func setupTableView() {
        justTableView.delegate = self
        justTableView.dataSource = self
        justTableView.register(
            JustTableViewCell.self,
            forCellReuseIdentifier: cellID
        )
    }
    
    private func mapToSrting(_ value: TableValue) -> String {
        switch value {
        case .indexPath(let indexPath):
            return "Row \(indexPath.row) | Section \(indexPath.section)".consoleLog("ℹ️")
        case .offSet(let offSet):
            return "OffSet \(offSet)".consoleLog("↕️")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: cellID,
                    for: indexPath
                ) as? JustTableViewCell
            else { return UITableViewCell() }
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
}

extension String {
    func consoleLog(_ emoji: String) -> String {
        [emoji, self].joined(separator:" ")
    }
}
