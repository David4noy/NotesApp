//
//  NotesViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//

import UIKit

class NotesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noNotesLabel: UILabel!
    
    private let viewModel = NotesViewModel()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.notesViewControllerTitle
        setupTableView()
        setupNavigationBar()
        setupActivityIndicator()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchNotes()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: Strings.noteCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Strings.noteCell)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addNoteButtonTapped() {
        addNote()
    }
    
    private func addNote() {
        let alertController = UIAlertController(title: Strings.addNote, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Strings.title
        }
        alertController.addTextField { textField in
            textField.placeholder = Strings.content
        }
        
        let saveAction = UIAlertAction(title: Strings.save, style: .default) { [weak self] _ in
            guard let title = alertController.textFields?[0].text,
                  let content = alertController.textFields?[1].text else {
                return
            }
            self?.viewModel.addNote(title: title, content: content, imageUrl: self?.imageUrl)
        }
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Strings.noteCell, for: indexPath) as? NoteCell {
            let note = viewModel.getNote(at: indexPath)
            cell.configure(with: note)
            return cell
        } else {
            print(Errors.errorDequeueNoteCell.rawValue)
            return tableView.dequeueReusableCell(withIdentifier: Strings.noteCell, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        if let showNoteVC = storyboard.instantiateViewController(identifier: Strings.showNoteViewController) as? ShowNoteViewController {
            let note = viewModel.getNote(at: indexPath)
            showNoteVC.note = note
            showNoteVC.noteIndex = indexPath
            showNoteVC.noteDelegate = self
            showNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(showNoteVC, animated: true)
        } else {
            print(Errors.noScreen.rawValue)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDelete(at: indexPath)
        }
    }
    
    private func confirmDelete(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: Strings.deleteNote, message: Strings.deleteNoteConfirmation, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: Strings.delete, style: .destructive) { [weak self] _ in
            self?.viewModel.removeNote(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

// MARK: - NotesViewModelDelegate
extension NotesViewController: NotesViewModelDelegate {
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
    
    func notesDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateNoNotesLabel()
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateNoNotesLabel() {
        if viewModel.getNumberOfRows() == 0 {
            noNotesLabel.isHidden = false
        } else {
            noNotesLabel.isHidden = true
        }
    }
}


// MARK: - ShowNoteViewControllerNoteDelegate
extension NotesViewController: ShowNoteViewControllerNoteDelegate {
    func didUpdateNoteAt(indexPath: IndexPath, with title: String, content: String, imagePath: String?) {
        viewModel.updateNote(at: indexPath, with: title, content: content, imagePath: imagePath)
    }
}


