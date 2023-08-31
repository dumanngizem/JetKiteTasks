//
//  SoundCell.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit

class SoundCell: UITableViewCell {
    static let cellId = "SoundCell"
    
    public var viewModel: SoundCellProtocol?
    
    private lazy var containerImageView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .init(systemName: "speaker")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .black
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func set(viewModel: SoundCellProtocol?) {
        self.viewModel = viewModel
        configureContents()
    }
}

// MARK: UILayout
extension SoundCell {
    
    private func addSubViews() {
        addContainerImageView()
        addIconImageView()
        addTitleLabel()
    }
    
    private func addContainerImageView() {
        contentView.addSubview(containerImageView)
        containerImageView.topToSuperview(offset: 8)
        containerImageView.leadingToSuperview(offset: 8)
        containerImageView.bottomToSuperview(offset: -8)
        containerImageView.width(45)
        containerImageView.height(45, relation: .equalOrGreater)
    }
    
    private func addIconImageView() {
        containerImageView.addSubview(iconImageView)
        iconImageView.centerInSuperview()
        iconImageView.width(24)
        iconImageView.height(24)
    }
    
    private func addTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.leadingToTrailing(of: containerImageView, offset: 8)
        titleLabel.centerY(to: containerImageView)
        titleLabel.bottomToSuperview(offset: -4, relation: .equalOrGreater)
        titleLabel.trailingToSuperview(offset: -8)
    }
}

// MARK: ConfigureContents
extension SoundCell {
    
    private func configureContents() {
        titleLabel.text = viewModel?.title
    }
}
