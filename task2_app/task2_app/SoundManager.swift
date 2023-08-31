//
//  SoundManager.swift
//  task2_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import Foundation
import AVFAudio

public final class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.1
            
            let volumeStep: Float = 1.0 / 60.0 // Her saniye için artış miktarı
            var currentVolume: Float = 0.0
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                currentVolume += volumeStep
                if currentVolume >= 1.0 {
                    self.audioPlayer?.volume = 1.0
                    timer.invalidate() // Timer'ı durdur
                } else {
                    self.audioPlayer?.volume = currentVolume
                }
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
