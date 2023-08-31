//
//  StopAlarmViewController.swift
//  task2_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints

class StopAlarmViewController: UIViewController {

    private lazy var stopButton: UIButton = {
       let button = UIButton()
        button.setTitle("Durdur", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(stopButton)
        stopButton.centerInSuperview()
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    @objc private func stopButtonTapped() {
        SoundManager.shared.stopAlarm()
    }
}
