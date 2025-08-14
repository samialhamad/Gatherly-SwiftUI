<img width="200" alt="gatherlyappicon 2" src="https://github.com/user-attachments/assets/e97ee603-73ed-4d4c-95ec-13bba675a9eb" />

# Gatherly

## Table Of Contents

- [Summary](#summary)
- [Demo](#demo)
- [Features](#features)
- [Skills](#skills)
- [Technologies](#technologies)
 
## Summary

Gatherly is an app I built to demonstrate my ability to build a modern iOS app using Swift and SwiftUI. It is designed as a calendar app for friends to schedule activities together.

## Demo

https://github.com/user-attachments/assets/35ad5437-3a2e-4b66-bf75-a653a94e7ed1

## Features

Gatherly supports contact syncing, deep linking into various map apps and prepopulating the destination.

Event Creation

* After creating an event, you will automatically be redirected to its detail page. From there, you can edit the event as long as it has not yet started.
* On the detail page, you can conveniently open the event's address using the map app of your choice.
* From the event list view for a specific day, you can quickly add an event for that day by tapping the plus icon in the corner, which will prepopulate the date in the event creation form. 

With Gatherly, you can easily sync your iPhone contacts directly into your friends list, or manually create friends if you choose. You can also create groups, which makes creating events with certain friend groups even easier.

Gatherly is primarily divided into four tabs, via a TabView in ContentView. Within each tab, there are various sheets, buttons, and subviews. The logic is separated from the UI as Gatherly follows an MVVM architecture.

The app contains a mock API layer which utilizes Combine Publishers to simulate real-world asynchronous behavior with set delays.

Gatherly is initialized with sample data the first time the app is launched, but supports persistence for any new data the user creates.

## Skills

Throughout the development of Gatherly, I learned a variety of fundamental technical skills, including:

* Ensuring consistent patterns and architecture across a medium-sized codebase
* Performing incremental refactors and code cleanup tasks
* Validating code through unit tests and UI tests, achieving 90% code coverage
* Defensive programming to anticipate and handle unexpected behavior or edge cases
* Inter-operation between UIKit and SwiftUI
* Separation of concerns, implementing an MVVM architecture

## Technologies

The technologies used in this app include:

### Languages & Frameworks
* Swift
* SwiftUI
* UIKit

### Architectural Patterns
* MVVM Architecture
* [TCA (The Composable Architecture) Reducers](https://github.com/pointfreeco/swift-composable-architecture)

### Reactive Programming
* Combine
* RxSwift

### iOS Libraries
* MapKit
* Contacts
* UserDefaults
* PhotosUI
* FileManager
  
### Third Party Libraries
* [SwiftyCrop](https://github.com/benedom/SwiftyCrop)
