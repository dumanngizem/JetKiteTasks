//
//  MyPlaylistView.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints

class MyPlayListView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        getPlayList()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: UILayout
extension MyPlayListView {
    
    private func addSubViews() {
        
    }
}

// MARK: Request
extension MyPlayListView {
    
    func getPlayList() {
        guard let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.addValue("Bearer YOUR_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("JSON Serialization Error: \(error)")
                }
            }
        }
        task.resume()
    }
}
