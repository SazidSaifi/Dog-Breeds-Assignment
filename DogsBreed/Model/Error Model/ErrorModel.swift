//
//  ErrorModel.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 09/07/24.
//

import Foundation
// MARK: - ErrorModel
struct ErrorModel: Codable, Error {
    
    let isSuccess: Bool?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try? (values.decodeIfPresent(Bool.self,forKey: .isSuccess))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
    }
}
