//
//  Article.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//
import Foundation

struct Article: Hashable, Codable, Identifiable {
    var id = UUID()
    var title: String
    var title_lowercase: String
    var date: Date
    var body: String
    var game: String
    var userID: String
    var links: [String]
}
