# Venues Locator

## Project Overview

I used **MVVM** with a Coordinator to manage the architecture, allowing clear separation between UI logic and data management, making the application easier to maintain and extend.

The project follows **Clean Architecture**, separating **data layers** (network, local storage), **business logic layers** (use cases), and **presentation layers** (view models, views).

The venue list automatically updates every 10 seconds using a mechanism simulating changing locations, with a smooth animation effect to enhance the user experience. These updates occur only in the foreground.

Unit tests are provided for business logic modules (use cases, view model, storage service), using mocked objects to improve performance.

## Design Decisions

- **Architecture and UI Framework**: I used **UIKit** since the company uses it in their projects, making this task relevant for demonstrating my skills in integrating with existing code. The **MVVM** pattern ensures the separation of business logic and UI.
- **Dependency Injection**: `VenueAPI` and `LocalStorageService` are injected, making testing easier and reducing tight coupling.
- **Offline Storage**: **UserDefaults** is used to manage favorite venues simply. For more complex requirements, I would consider **CoreData** or **SQLite**.
- **Use Cases for Business Logic**: Business logic is isolated from ViewModels to make testing more straightforward.
- **ViewModel Management**: **VenuesViewModel** encapsulates UI state and business logic, keeping the UI responsive and reducing direct UI handling.
- **Protocols for Testability**: `FetchVenuesUseCaseProtocol` and `UpdateFavouriteUseCaseProtocol` enhance testability through dependency injection.

## Further Improvements

- **API Improvement**: Optimize load time by requesting only the first 15 venues.
- **Improvement During Decoding**: I could limit the venues to the first 15 items during the decoding process, slightly improving CPU usage. However, the preferred approach would be to enforce this limit in the API request to reduce the data sent from the server.
- **Use Protocols for All Services**: Extend protocol usage to other services for better testability.
- **Enhanced Error Handling**: Implement comprehensive error handling and error logging using tools like **Firebase** or **Datadog**.
- **Multi-Module Architecture**: Consider a multi-module project structure for better separation and maintainability.
- **Switch to CoreData**: Use **CoreData** for managing more complex data relationships.
- **Preferred Stack**: Migrate to **SwiftUI + MVVM** to align with modern best practices.
- **Async/Await**: Manage concurrent tasks using **async/await**.
- **Extended Testing**: Add more unit and UI tests to cover common and edge cases.
- **Reusable UI Components**: Create reusable components (typography styles, color themes) for consistency.
- **Swipe-to-Refresh**: Allow users to refresh venue lists interactively.
