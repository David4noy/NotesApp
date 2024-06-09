//
//  MapViewModel.swift
//  NoteApp
//
//  Created by דוד נוי on 08/06/2024.
//

import Foundation
import CoreLocation
import MapKit

protocol MapViewModelDelegate: AnyObject {
    func didUpdateNotes()
}

class MapViewModel {
    private var notes: [Note] = []
    weak var delegate: MapViewModelDelegate?

    func fetchNotes() {
        if let savedNotes = DataServices.shared.readNotesFromFile() {
            self.notes = savedNotes
            delegate?.didUpdateNotes()
        }
    }

    func getAnnotations() -> [MKAnnotation] {
        return notes.map { note in
            let annotation = MKPointAnnotation()
            annotation.title = note.title
            annotation.subtitle = note.content
            if let location = note.location {
                annotation.coordinate = location
            }
            return annotation
        }
    }

    func getNoteForAnnotation(_ annotation: MKAnnotation) -> Note? {
        return notes.first { note in
            note.location?.latitude == annotation.coordinate.latitude &&
            note.location?.longitude == annotation.coordinate.longitude
        }
    }

    func editNote(_ note: Note, newTitle: String, newContent: String, imagePath: String?) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].title = newTitle
            notes[index].content = newContent
            notes[index].imageUrl = imagePath
            DataServices.shared.saveNotesToFile(notes: notes)
            delegate?.didUpdateNotes()
        }
    }

    func removeNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        DataServices.shared.saveNotesToFile(notes: notes)
        delegate?.didUpdateNotes()
    }
}

