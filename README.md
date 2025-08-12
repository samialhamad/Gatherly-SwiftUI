<img width="800" alt="Screenshot 2025-08-12 at 4 38 23 PM" src="https://github.com/user-attachments/assets/9c978f55-e04a-496e-9ec1-b1f69209d6ad" />

# Gatherly

## Table Of Contents

- [Summary](#-summary)
- [Demo](#-demo)
- [Structure](#-structure)
- [Skills](#-skills)
- [Technical](#-technical)
- [Libraries](#-libraries)
 
## Summary

Gatherly is an app I built to demonstrate my ability to build a modern iOS app using Swift and SwiftUI. The app is intended to be a calendar app used amongst friends to schedule activities.

## Demo

[Demo Video - YouTube](https://youtu.be/L7QkI5mkXu0?si=TjrbIjOPUH5lnRDo)

## Features

Gatherly supports contact syncing, deeplinking into various map apps and prepopulating the destination.

Event Creation

* After creating an event, you will automatically be redirected to it's detail page. From there, you can edit the event as long as it has not yet started
* On the detail page, you can conveniently open the event's address using the map app of your choice
* From the event list view for a specific day, you can quickly add an event for that day by tapping the plus icon in the corner, which will prepopulate the date in the event creation form 

With Gatherly, you can easily sync your iPhone contacts directly into your friends list, or manually create friends if you choose. You can also create groups, which makes creating events with certain friend groups even easier.

Gatherly is primarily divided into four tabs, via a TabView in ContentView. Within each tab, there are various sheets, buttons, and subviews. The logic is separated from the UI as Gatherly follows an MVVM architecture.

The app contains a mock API layer which utilizes Combine Publishers to simulate real-world asynchronous behavior with set delays

Gatherly is initialized with sample data the first time the app is launched, but supports persistence for any new data the user creates.

## Skills

Throughout the development of Gatherly, I learned a variety of fundamental technical skills, including:

* Ensuring consistent patterns and architecture across a medium sized codebase
* Performing incremental refactors and code cleanup tasks
* Validating code through unit tests and UI tests, achieving 90% code coverage
* Defensive programming to anticipate and handle unexpected behavior or edge-cases
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
