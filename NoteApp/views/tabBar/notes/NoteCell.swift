//
//  NoteCell.swift
//  NoteApp
//
//  Created by דוד נוי on 09/06/2024.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    
    func configure(with note: Note) {
        noteTitle.text = note.title
        contentLabel.text = note.content
        if let imagePath = note.imageUrl {
            noteImageView.image = DataServices.shared.getImage(from: imagePath)
        } else {
            noteImageView.image = UIImage(systemName: "photo")
        }
    }
    
}
