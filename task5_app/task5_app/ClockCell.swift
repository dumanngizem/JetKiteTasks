//
//  ClockCell.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//
import UIKit

class ClockCell: UITableViewCell {
    static let cellId = "ClockCell"
        
    private lazy var clockLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "22"
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .gray
        label.text = "ONCE"
        return label
    }()
    
    private lazy var onSwitch: UISwitch = {
       let onSwitch = UISwitch()
        return onSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var item: ClockCellModel? {
        didSet {
            configureContents()
        }
    }
}

// MARK: UILayout
extension ClockCell {
    
    private func addSubViews() {
        addClockLabel()
        addTypeLabel()
        addOnSwitch()
    }
    
    private func addClockLabel() {
        contentView.addSubview(clockLabel)
        clockLabel.topToSuperview(offset: 8)
        clockLabel.leftToSuperview(offset: 8)
    }
    
    private func addTypeLabel() {
        contentView.addSubview(typeLabel)
        typeLabel.topToBottom(of: clockLabel, offset: 4)
        typeLabel.leading(to: clockLabel)
        typeLabel.trailingToSuperview(offset: -8)
        typeLabel.bottomToSuperview(offset: -4)
    }
    
    private func addOnSwitch() {
        contentView.addSubview(onSwitch)
        onSwitch.trailingToSuperview(offset: 8)
        onSwitch.leadingToTrailing(of: clockLabel, relation: .equalOrGreater)
        onSwitch.centerY(to: clockLabel)
    }
}

// MARK: ConfigureContents
extension ClockCell {
    
    private func configureContents() {
        clockLabel.text = item?.clock
        typeLabel.text = item?.type
        onSwitch.isOn = item?.isOpen ?? false
    }
}
