# NoteApp

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Usage](#usage)
    - [Login and User Check](#login-and-user-check)
    - [Navigating to the Main Tab Bar](#navigating-to-the-main-tab-bar)
    - [User Screen](#user-screen)
    - [Notes](#notes)
    - [Map Screen](#map-screen)
    - [Location Services](#location-services)
5. [Dependencies](#dependencies)

## Introduction

NoteApp is an iOS application that allows users to create, edit, and manage notes. The app supports text notes, images, and location tagging. Notes are stored locally and can be viewed in a list format.

## Features

- **User Screen:** Displays a list of users and allows interaction with user data.
- **Notes:** Add, edit, delete notes with title, content, optional image, and location.
- **Map Screen:** Visualizes notes on a map based on their tagged locations.
- **Login and User Check:** Ensures secure access and remembers user sessions.

## Architecture

The app follows the Model-View-ViewModel (MVVM) architecture pattern.

- **Model:** Contains the data structures and business logic.
- **View:** The UI components like view controllers and views.
- **ViewModel:** Handles the data binding between the model and the view, business logic, and acts as a delegate for location services.

## Usage

### Login and User Check

Upon app launch, the SceneDelegate checks if the user is logged in:

- If the user is already logged in, they are navigated directly to the Main Tab Bar.
- If not, the user is presented with the login screen.

### Navigating to the Main Tab Bar

The Main Tab Bar contains three main screens:

1. **User Screen:** First tab
2. **Notes:** Second tab
3. **Map Screen:** Third tab

### User Screen

The User Screen (UsersViewController) is the first tab in the Main Tab Bar. It displays a list of users and handles downloading and presenting user data.

### Notes

The Notes feature is accessed through the second tab in the Main Tab Bar.

#### Adding a Note

1. Tap the "Add" button to open the Add Note screen.
2. Enter the title and content for the note.
3. Save the note by tapping the "Save" button.

#### Editing a Note

1. Tap on the note you want to edit.
2. Modify the title, content, or image.
3. Save the changes by tapping the "Save" button.

#### Deleting a Note

1. Swipe left on the note you want to delete.
2. Tap the "Delete" button that appears.

### Map Screen

The Map Screen is accessed through the third tab in the Main Tab Bar. It visualizes the notes on a map based on their tagged locations. The user can see the geographical distribution of their notes.

### Location Services

The app uses CoreLocation to tag notes with the current location.

- On first launch, the app requests permission to access the device's location.
- If the permission is granted, the app can tag notes with the current location.
- If the permission is denied or restricted, an alert is shown to the user with instructions.

### Dependencies

- **CoreLocation:** Used for obtaining the current location of the device.
- **UIKit:** Provides the UI components and event handling.
