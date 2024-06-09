//
//  UserViewModel.swift
//  NoteApp
//
//  Created by דוד נוי on 06/06/2024.
//

import UIKit
import SDWebImage

protocol UserViewModelDelegate: AnyObject {
    func didUpdateUsers()
    func activityIndicatorHandler(isLoading: Bool)
}

class UserViewModel {
    private var users: [User] = []
    weak var delegate: UserViewModelDelegate?

    func fetchUsers() {
        delegate?.activityIndicatorHandler(isLoading: true)
        if let cachedUsers = DataServices.shared.readUsersFromFile() {
            self.users = cachedUsers
            delegate?.didUpdateUsers()
            delegate?.activityIndicatorHandler(isLoading: false)
        } else {
            downloadUsers()
        }
    }
    
    private func downloadUsers() {
        DataServices.shared.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.delegate?.didUpdateUsers()
            case .failure(let error):
                print("\(Errors.failedToFetchUsers): \(error)")
            }
            self?.delegate?.activityIndicatorHandler(isLoading: false)
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        return users.count
    }
    
    func getUser(indexPath: IndexPath) -> User {
        return users[indexPath.row]
    }
    
    func getUserFullName(indexPath: IndexPath) -> String {
        let user = users[indexPath.row]
        return "\(user.firstName) \(user.lastName)"
    }
    
    func getUserAvatarURL(indexPath: IndexPath) -> String {
        return users[indexPath.row].avatar
    }
}
