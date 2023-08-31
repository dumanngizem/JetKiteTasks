//
//  ViewController.swift
//  task3_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints

class ViewController: UIViewController {
    
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    var selectedHour = 0
    var selectedMinute = 0
    
    let pickerView = UIPickerView()
    var timer: Timer?
    var isPlay: Bool = false {
        didSet {
            let title = isPlay ? "Duraklat" : "Oynat"
            playButton.setTitle(title, for: .normal)
        }
    }
    
    var isSetButtonActive: Bool = true {
        didSet {
            let title = isSetButtonActive ? "Ayarla" : "Sıfırla"
            setButton.setTitle(title, for: .normal)
        }
    }
    
    var remainingTimeInterval: TimeInterval = 0
    
    private lazy var titleContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "deneme"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .green
        button.setTitle("Oynat", for: .normal)
        return button
    }()
    
    private lazy var setButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .gray
        button.setTitle("Ayarla", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configureContents()
    }
}

// MARK: - UILayouts
extension ViewController {
    
    private func addSubViews() {
        addPickerView()
        addTitleContainer()
        addTitleLabel()
        addPlayButton()
        addSetButton()
    }
    
    private func addPickerView() {
        view.addSubview(pickerView)
        pickerView.centerYToSuperview(multiplier: 0.6)
        pickerView.horizontalToSuperview(insets: .horizontal(32))
    }
    
    private func addTitleContainer() {
        view.addSubview(titleContainer)
        titleContainer.topToBottom(of: pickerView, offset: 32)
        titleContainer.centerXToSuperview()
        titleContainer.width(100)
        titleContainer.height(50)
    }
    
    private func addTitleLabel() {
        titleContainer.addSubview(titleLabel)
        titleLabel.edgesToSuperview(insets: .horizontal(4) + .vertical(4))
    }
    
    private func addPlayButton() {
        view.addSubview(playButton)
        playButton.topToBottom(of: titleContainer, offset: 16)
        playButton.centerXToSuperview()
        playButton.width(100)
        playButton.height(40)
    }
    
    private func addSetButton() {
        view.addSubview(setButton)
        setButton.topToBottom(of: playButton, offset: 16)
        setButton.centerXToSuperview()
        setButton.width(100)
        setButton.height(40)
    }
}

// MARK: - Configure Contents
extension ViewController {
    
    private func configureContents() {
        configurePickerView()
        configureView()
        configureTitleLabel()
        configureButtons()
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "\(selectedHour):\(selectedMinute)"
    }
    
    private func configureButtons() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.remainingTimeInterval > 0 {
                self.remainingTimeInterval -= 1
                self.updateTimeLabel(with: self.remainingTimeInterval)
            } else {
                self.stopTimer()
            }
        }
        self.pickerView.isUserInteractionEnabled = false
    }
    
    func updateTimeLabel(with timeInterval: TimeInterval) {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        titleLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func stopTimer() {
        pauseTimer()
        remainingTimeInterval = 0
        updateTimeLabel(with: remainingTimeInterval)
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Zamanlayıcı Doldu!"
        content.body = "Zamanlayıcı Doldu!"
        content.sound = UNNotificationSound.default
        let currentDate = Date()
        let triggerDate = Calendar.current.date(byAdding: .minute, value: selectedMinute, to: currentDate)
        
        guard let triggerDate = triggerDate else {
            return
        }
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_sound.caf"))

          
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDate.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: "stopTimer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

// MARK: Actions
extension ViewController {
    
    @objc private func playButtonTapped() {
        if isPlay {
            timer?.invalidate()
            timer = nil
        } else {
            if remainingTimeInterval <= 0 {
                let totalTimeInterval = TimeInterval(selectedHour * 3600 + selectedMinute * 60)
                remainingTimeInterval = totalTimeInterval
            }
            startTimer()
        }
        self.isPlay.toggle()
    }
    
    @objc private func setButtonTapped() {
        
        if isSetButtonActive {
            self.pickerView.isUserInteractionEnabled = true
            pauseTimer()
            self.isPlay = false
        } else {
            stopTimer()
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        isSetButtonActive.toggle()
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hours.count : minutes.count
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let value: Int
        if component == 0 {
            value = hours[row]
        } else {
            value = minutes[row]
        }
        
        let stringValue = String(format: "%02d", value)
        let attributedString = NSAttributedString(string: stringValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = hours[row]
        } else {
            selectedMinute = minutes[row]
        }
        let formattedHour = String(format: "%02d", selectedHour)
        let formattedMinute = String(format: "%02d", selectedMinute)
        let message = "\(formattedHour):\(formattedMinute)"
        print("Selected Hour: \(selectedHour), Minute: \(selectedMinute)")
        titleLabel.text = message
        let totalTimeInterval = TimeInterval(selectedHour * 3600 + selectedMinute * 60)
            remainingTimeInterval = totalTimeInterval
        scheduleNotification()
    }
}
