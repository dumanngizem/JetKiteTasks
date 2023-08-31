//
//  BottomSheet.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//
import UIKit

class BottomSheet: UIViewController {
    
    private lazy var segmentView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Sounds", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Playlist", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Songs", at: 2, animated: false)
        return segmentedControl
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var soundsView = SoundsView()
    private lazy var playListView = MyPlayListView()
    private lazy var view3 = UIView()
    
    private var viewArray: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(segmentView)
        segmentView.horizontalToSuperview(insets: .horizontal(16))
        segmentView.topToSuperview(offset: 8, usingSafeArea: true)
        segmentView.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentView.selectedSegmentIndex = 0
        
        view.addSubview(stackView)
        stackView.edgesToSuperview(excluding: .top)
        stackView.topToBottom(of: segmentView)
        
        view3.backgroundColor = .green
        viewArray = [soundsView, playListView, view3]
        stackView.addArrangedSubview(viewArray[0])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundManager.shared.stopAlarm()
    }
}

// MARK: Actions
extension BottomSheet {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        stackView.removeAllArrangedSubviews()
        let selected = viewArray[sender.selectedSegmentIndex]
        stackView.addArrangedSubview(selected)
    }
}
