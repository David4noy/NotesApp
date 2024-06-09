//
//  MapViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 08/06/2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.mapViewControllerTitle
        mapView.delegate = self
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchNotes()
    }
    
    private func addAnnotations() {
        let annotations = viewModel.getAnnotations()
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = Strings.noteAnnotation
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let editButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = editButton
            
            let removeButton = UIButton(type: .close)
            annotationView?.leftCalloutAccessoryView = removeButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        guard let note = viewModel.getNoteForAnnotation(annotation) else { return }
        
        if control == view.rightCalloutAccessoryView {
            showNote(note: note)
        } else if control == view.leftCalloutAccessoryView {
            removeNote(note: note)
        }
    }
    
    private func showNote(note: Note) {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        if let showNoteVC = storyboard.instantiateViewController(identifier: Strings.showNoteViewController) as? ShowNoteViewController {
            showNoteVC.note = note
            showNoteVC.mapDelegate = self
            showNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(showNoteVC, animated: true)
        } else {
            print(Errors.noScreen.rawValue)
        }
    }
    
    private func removeNote(note: Note) {
        let alertController = UIAlertController(title: Strings.deleteNote, message: Strings.deleteNoteConfirmation, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: Strings.delete, style: .destructive) { [weak self] _ in
            self?.viewModel.removeNote(note)
        }
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: MapViewModelDelegate {
    func didUpdateNotes() {
        DispatchQueue.main.async { [weak self] in
            self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            self?.addAnnotations()
        }
    }
}

extension MapViewController: ShowNoteViewControllerMapDelegate {
    func didUpdateNoteAt(note: Note, with title: String, content: String, imagePath: String?) {
        viewModel.editNote(note, newTitle: title, newContent: content, imagePath: imagePath)
    }
}
