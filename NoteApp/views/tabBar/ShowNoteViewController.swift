//
//  ShowNoteViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 08/06/2024.
//

import UIKit

protocol ShowNoteViewControllerNoteDelegate: AnyObject {
    func didUpdateNoteAt(indexPath: IndexPath, with title: String, content: String, imagePath: String?)
}

protocol ShowNoteViewControllerMapDelegate: AnyObject {
    func didUpdateNoteAt(note: Note, with title: String, content: String, imagePath: String?)
}

class ShowNoteViewController: UIViewController {
    
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var noteImageView: UIImageView!
    
    var note: Note?
    var noteIndex: IndexPath?
    weak var noteDelegate: ShowNoteViewControllerNoteDelegate?
    weak var mapDelegate: ShowNoteViewControllerMapDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.shoeNoteViewControllerTitle
        setupView()
        setupNavigationBar()
        setupTapGestureRecognizer()        
    }

    private func setupView() {
        guard let note = note else { return }
        titleTextView.text = note.title
        contentTextView.text = note.content
        
        if let imagePath = note.imageUrl,
           let image = DataServices.shared.getImage(from: imagePath) {
            noteImageView.image = image
        } else {
            noteImageView.image = UIImage(systemName: "photo")
        }
        
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.borderWidth = 1.0
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.masksToBounds = true

        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 8.0
        contentTextView.layer.masksToBounds = true
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc private func saveButtonTapped() {
        saveNote()
    }

    private func saveNote() {
        guard let note = note else { return }
        guard let newTitle = titleTextView.text, !newTitle.isEmpty,
              let newContent = contentTextView.text, !newContent.isEmpty else { return }
        
        let imagePath = note.imageUrl
        
        if let indexPath = noteIndex {
            noteDelegate?.didUpdateNoteAt(indexPath: indexPath, with: newTitle, content: newContent, imagePath: imagePath)
        } else {
            mapDelegate?.didUpdateNoteAt(note: note, with: newTitle, content: newContent, imagePath: imagePath)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        noteImageView.isUserInteractionEnabled = true
        noteImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imageViewTapped() {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ShowNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Save the image and get the path
            if let imagePath = DataServices.shared.saveImage(selectedImage) {
                // Update the note's image URL with the relative path
                note?.imageUrl = imagePath
                
                // Update the image view
                noteImageView.image = selectedImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
