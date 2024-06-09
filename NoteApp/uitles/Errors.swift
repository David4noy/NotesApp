//
//  Errors.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//

import Foundation

enum Errors: String, Error {
    case urlError = "There was an error with the URL."
    case noData = "No data received from the server."
    case noScreen = "The screen was not found"
    case decodingError = "Failed to decode the received data."
    case networkError = "There was a network error."
    case fileError = "Failed to read/write data from/to file."
    case loginFailed = "Login failed. Please check your credentials."
    case registrationFailed = "Registration failed. Please try again."
    case noteCreationFailed = "Failed to create a new note."
    case noteRemovalFailed = "Failed to remove the note."
    case noteEditingFailed = "Failed to edit the note."
    case locationError = "Failed to retrieve user's location."
    case failedToFetchUsers = "Failed to fetch users"
    case failedToReadUsersFromFile = "Failed to read users from file"
    case failedToSaveUsersFromFile = "Failed to save users to file"
    case failedToSaveNotesToFile = "Failed to save notes to file"
    case failedToReadNotesFromFile = "Failed to read notes from file"
    case errorDequeueNoteCell = "Error casting and dequeueReusableCell for NoteCell"
}
