//
//  UserInfoViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//
import UIKit
import SDWebImage

class UserInfoViewController: UIViewController {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var userId: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let user = user else { return }
        
        fullNameLabel.text = "Full Name: \(user.firstName) \(user.lastName)"
        userId.text = "ID: \(user.id)"
        emailLabel.text = "Email: \(user.email)"
        genderLabel.text = "Gender: \(user.gender)"
        if let url = URL(string: user.avatar) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle"))
        }
    }
}
