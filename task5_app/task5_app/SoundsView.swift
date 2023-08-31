//
//  SoundsView.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints

class SoundsView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SoundCell.self, forCellReuseIdentifier: SoundCell.cellId)
        return tableView
    }()
    
    private var cellItems: [SoundCellProtocol]?
    private var selectedIndexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        tableView.delegate = self
        tableView.dataSource = self
        cellItems = [
            SoundCellModel(title: "Crystal Drop", bundleURL: "crytal_drop"),
            SoundCellModel(title: "Digital", bundleURL: "digital"),
            SoundCellModel(title: "Smoke Alarm", bundleURL: "smoke_alarm"),
            SoundCellModel(title: "Rooster", bundleURL: "rooster"),
            SoundCellModel(title: "Bleep", bundleURL: "bleep")
        ]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
}

// MARK: UILayout
extension SoundsView {
    
    private func addSubViews() {
        addSubview(tableView)
        tableView.edgesToSuperview()
    }
}

extension SoundsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = cellItems?[indexPath.row] else { return }
        SoundManager.shared.playAlarmSound(item.bundleURL)
        if let selectedIndexPath = selectedIndexPath, let selectedCell = tableView.cellForRow(at: selectedIndexPath) {
            selectedCell.accessoryType = .none
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            // Seçilen hücrenin seçim durumunu güncelle
            selectedIndexPath = indexPath
            cell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SoundsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SoundCell = tableView.dequeueReusableCell(withIdentifier: SoundCell.cellId, for: indexPath) as! SoundCell
        let viewModel = cellItems?[indexPath.row]
        cell.set(viewModel: viewModel)
        return cell
    }
}
