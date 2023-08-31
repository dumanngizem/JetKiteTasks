//
//  ViewController.swift
//  task2_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints
import UserNotifications
import AVFoundation

class ViewController: UIViewController {
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    var selectedHour = 0
    var selectedMinute = 0
    
    let pickerView = UIPickerView()
    
    private let setAlarmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 29
        button.setTitle("Set Alarm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureContents()
        addTargets()
    }
}

// MARK: - UILayouts
extension ViewController {
    
    private func addSubViews() {
        addPickerView()
        addSetAlarmButton()
    }
    
    private func addPickerView() {
        view.addSubview(pickerView)
        pickerView.centerYToSuperview(multiplier: 0.6)
        pickerView.horizontalToSuperview(insets: .horizontal(32))
    }
    
    private func addSetAlarmButton() {
        view.addSubview(setAlarmButton)
        setAlarmButton.centerYToSuperview(multiplier: 1.5)
        setAlarmButton.horizontalToSuperview(insets: .horizontal(64))
        setAlarmButton.height(60)
    }
}

// MARK: - Configure Contents
extension ViewController {
    
    private func configureContents() {
        configurePickerView()
        configureView()
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Add Targets
extension ViewController {
    
    private func addTargets() {
        setAlarmButton.addTarget(self, action: #selector(setAlarmTapped), for: .touchUpInside)
    }
}

// MARK: - Actions
extension ViewController {
    
    @objc
    private func setAlarmTapped() {
        let formattedHour = String(format: "%02d", selectedHour)
        let formattedMinute = String(format: "%02d", selectedMinute)
        
        let message = "Alarm is set for \(formattedHour):\(formattedMinute)"
        let alertController = UIAlertController(title: "Alarm Set", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        scheduleNotification()
    }
}

// MARK: Name
extension ViewController {
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Uyan!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
        print("Selected Hour: \(selectedHour), Minute: \(selectedMinute)")
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == "alarm" {
            
        }
        
        completionHandler([.alert, .sound])
    }
}
