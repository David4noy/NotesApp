//
//  UsersViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 06/06/2024.
//

import UIKit
import SDWebImage

class UsersViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = UserViewModel()
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.usersViewControllerTitle
        viewModel.delegate = self
        viewModel.fetchUsers()
        setupTableView()
        setupActivityIndicator()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellReuseIdentifierUser)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellReuseIdentifierUser, for: indexPath)
        
        cell.textLabel?.text = viewModel.getUserFullName(indexPath: indexPath)
        
        let userAvatarURL = viewModel.getUserAvatarURL(indexPath: indexPath)
        let defaultImage = UIImage(systemName: "person.circle")
        cell.imageView?.sd_setImage(with:URL(string: userAvatarURL), placeholderImage: defaultImage)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.getUser(indexPath: indexPath)
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        if let userInfoVC = storyboard.instantiateViewController(withIdentifier: Strings.userInfoViewController) as? UserInfoViewController {
            userInfoVC.user = user
            userInfoVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(userInfoVC, animated: true)
        } else {
            print(Errors.noScreen.rawValue)
        }
    }
}

extension UsersViewController: UserViewModelDelegate {
    func activityIndicatorHandler(isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.activityIndicator.startAnimating()
                self?.view.isUserInteractionEnabled = false
            } else {
                self?.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func didUpdateUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
