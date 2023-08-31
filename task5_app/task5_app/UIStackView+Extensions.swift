//
//  UIStackView+Extensions.swift
//  task5_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
