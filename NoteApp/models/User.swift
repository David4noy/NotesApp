//
//  User.swift
//  NoteApp
//
//  Created by דוד נוי on 06/06/2024.
//

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case gender
        case avatar
    }
}
