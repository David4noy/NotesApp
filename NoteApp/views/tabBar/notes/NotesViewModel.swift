//
//  NotesViewModel.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//

import CoreLocation
import UIKit

protocol NotesViewModelDelegate: AnyObject {
    func notesDidUpdate()
    func showAlert(withTitle title: String, message: String)
    func activityIndicatorHandler(isLoading: Bool)
}

class NotesViewModel: NSObject {
    
    
    private var notes: [Note] = []
    
    weak var delegate: NotesViewModelDelegate?

    override init() {
        super.init()
    }

    func fetchNotes() {
        delegate?.activityIndicatorHandler(isLoading: true)
        if let savedNotes = DataServices.shared.readNotesFromFile() {
            self.notes = savedNotes
            delegate?.notesDidUpdate()
            delegate?.activityIndicatorHandler(isLoading: false)
        } else {
            delegate?.activityIndicatorHandler(isLoading: false)
        }
    }

    func getNumberOfRows() -> Int {
        return notes.count
    }

    func getNote(at indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }
    
    func getImage(imagePath: String?) -> UIImage? {
        if let imagePath = imagePath,
           let image = DataServices.shared.getImage(from: imagePath) {
            return image
        } else {
            return UIImage(systemName: "photo")
        }
    }

    func addNote(title: String, content: String, imageUrl: String?) {
        var location: CLLocationCoordinate2D?

        let locationManager = LocationManager()
        locationManager.delegate = self
        locationManager.checkLocationAuthorizationStatus()
        location = locationManager.location
                
        let note = Note(title: title, content: content, location: location, imageUrl: imageUrl)
        notes.append(note)
        DataServices.shared.saveNotesToFile(notes: notes)
        delegate?.notesDidUpdate()
    }
    
    func removeNote(at indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        DataServices.shared.saveNotesToFile(notes: notes)
        delegate?.notesDidUpdate()
    }
    
    func updateNote(at indexPath: IndexPath, with title: String, content: String, imagePath: String?) {
        notes[indexPath.row].title = title
        notes[indexPath.row].content = content
        notes[indexPath.row].imageUrl = imagePath
        DataServices.shared.saveNotesToFile(notes: notes)
        delegate?.notesDidUpdate()
    }
}

extension NotesViewModel: LocationManagerDelegate {
    func showAlert(withTitle title: String, message: String) {
        delegate?.showAlert(withTitle: title, message: message)
    }
}
