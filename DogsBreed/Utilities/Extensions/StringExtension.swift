//
//  StringExtension.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 10/07/24.
//

import Foundation

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
}
