//
//  ViewController.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ClockCell.self, forCellReuseIdentifier: ClockCell.cellId)
        return tableView
    }()
    
    var clockData: [ClockCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var plusButton: UIButton = {
       let button = UIButton()
        button.setImage(.add, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configureContents()
    }
}

// MARK: UILayout
extension ViewController {
    
    private func addSubViews() {
        addTableView()
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
}

// MARK: ConfigureContents
extension ViewController {
    
    private func configureContents() {
        tableView.delegate = self
        tableView.dataSource = self
        configureNavigationBar()
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Alarms"
        let rightButton = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: Actions
extension ViewController {
    @objc private func plusButtonTapped() {
        let randomIsOpen = [true, false]
        let model = ClockCellModel(clock: "22:30", type: "ONCE", isOpen: randomIsOpen.randomElement() ?? false)
        clockData.append(model)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BottomSheet()
        vc.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ClockCell = tableView.dequeueReusableCell(withIdentifier: ClockCell.cellId, for: indexPath) as! ClockCell
        let item = clockData[indexPath.row]
        cell.item = item
        return cell
    }
}
