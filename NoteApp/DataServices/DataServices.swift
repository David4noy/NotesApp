//
//  DataServices.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//

import UIKit

class DataServices {
    
    static let shared = DataServices()
    
    private let usersJSONURL = "https://api.mockaroo.com/api/729a5c80?count=120&key=947b40d0"
    private let usersFileName = "users.json"
    private let notesFileName = "notes.json"
    private let imagesDirectoryName = "images"
    private let imageExtension = ".jpeg"
    
    private init () {}
    
    // MARK: - Users
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: usersJSONURL) else {
            completion(.failure(Errors.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(Errors.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self.saveUsersToFile(users: users)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    func readUsersFromFile() -> [User]? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(usersFileName)
        do {
            let data = try Data(contentsOf: fileURL)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            print("\(Errors.failedToReadUsersFromFile): \(error)")
            return nil
        }
    }
    
    private func saveUsersToFile(users: [User]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(usersFileName)
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL)
        } catch {
            print("\(Errors.failedToSaveUsersFromFile): \(error)")
        }
    }
    
    // MARK: - Notes
    
    func saveNotesToFile(notes: [Note]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(notesFileName)
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL)
        } catch {
            print("\(Errors.failedToSaveNotesToFile): \(error)")
        }
    }
    
    func readNotesFromFile() -> [Note]? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(notesFileName)
        do {
            let data = try Data(contentsOf: fileURL)
            let notes = try JSONDecoder().decode([Note].self, from: data)
            return notes
        } catch {
            print("\(Errors.failedToReadNotesFromFile): \(error)")
            return nil
        }
    }
    
    // MARK: - images
    private var imagesDirectory: URL? {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imagesDirectory = documentsDirectory.appendingPathComponent(imagesDirectoryName)
            if !fileManager.fileExists(atPath: imagesDirectory.path) {
                do {
                    try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating images directory: \(error)")
                    return nil
                }
            }
            return imagesDirectory
        }
        return nil
    }
    
    func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let imagesDirectory = imagesDirectory else { return nil }
        
        let imageName = UUID().uuidString + imageExtension
        let filePath = imagesDirectory.appendingPathComponent(imageName)
        
        do {
            try data.write(to: filePath)
            return "\(imagesDirectoryName)/\(imageName)"
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func getImage(from path: String) -> UIImage? {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fullPath = documentsDirectory?.appendingPathComponent(path)
            if let fullPath = fullPath {
                return UIImage(contentsOfFile: fullPath.path)
            } else {
                return nil
            }

    }
    
    // MARK: - Helper methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
