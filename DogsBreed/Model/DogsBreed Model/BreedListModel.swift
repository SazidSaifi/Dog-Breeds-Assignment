//  BreedListModel.swift
//  DogsBreed
//  Created by Sazid Saifi on 09/07/24.

import Foundation

// MARK: - Welcome
struct BreedListModel: Codable {
    let message: [String: [String]]
    let status: String
}
