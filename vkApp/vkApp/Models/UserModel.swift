//
//  UserModel.swift
//  vkApp
//
//  Created by Юля on 27.06.21.
//

import Foundation

struct User: Decodable {
    let response: [Response]
}

struct Response: Decodable {
    let id: Int
    let first_name: String?
    let last_name: String?
    let photo_200_orig: String?
}

