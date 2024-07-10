//
//  UIViewExtensions.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 10/07/24.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 0.5
        self.layer.shadowOpacity = 1.0//0.5
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
