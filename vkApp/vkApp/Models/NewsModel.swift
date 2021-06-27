//
//  NewsModel.swift
//  vkApp
//
//  Created by Юля on 26.06.21.
//

import Foundation

struct FeedResponce: Decodable {
    let response: Items
}

struct Items: Decodable {
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachments]?
}

struct Attachments: Decodable {
    let type: String?
    let photo: Photos?
}

struct Photos: Decodable {
    let accessKey: String
    let sizes: [Size]?
}

struct Size: Decodable {
    let url: String?
    let height: Int?
    let type: String?
    let width: Int?
}

struct CountableItem: Decodable {
    let count: Int
}


