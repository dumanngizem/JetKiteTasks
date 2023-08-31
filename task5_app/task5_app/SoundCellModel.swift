//
//  SoundCellModel.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import Foundation

protocol SoundCellProtocol {
    var title: String { get set }
    var bundleURL: String { get set }
}

struct SoundCellModel: SoundCellProtocol {
    
    var title: String
    var bundleURL: String
    
    init(title: String, bundleURL: String) {
        self.title = title
        self.bundleURL = bundleURL
    }
}
