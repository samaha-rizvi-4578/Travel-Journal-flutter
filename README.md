## 👥 Group Members — **GROUP 7**

1. **Muhammad Tahir** (21k-4503)
2. **Syeda Samaha Batool Rizvi** (21k-4578)
3. **Insha Javed** (21k-3279)
4. **Muhammad Umer** (21k-3219)

---

# Travel Journal

**Travel Journal** is a Flutter application designed to help users document and share their travel experiences. The app allows users to create, edit, and view travel journals, complete with images, notes, moods, and location data. It also integrates with Firebase for data storage and authentication, and provides a map view to visualize visited locations.

---

## ✨ Features

- **Add New Journals**: Users can create new travel journals by providing details such as the place name, mood, notes, budget, and whether the location has been visited.
- **Edit Journals**: Existing journals can be updated with new information, including uploading images.
- **View Journals**: Users can view detailed information about their travel journals, including images, notes, and location data.
- **Map Integration**: Visualize visited locations on a map.
- **Firebase Integration**: Journals are stored in Firebase Firestore, and images are uploaded to Firebase Storage.
- **Authentication**: User authentication is handled via Firebase Authentication.
- **Offline Support**: Journals can be accessed offline with cached data.

---

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Firebase project configured with Firestore, Storage, and Authentication
- Android Studio or Visual Studio Code
- A physical or virtual device for testing

### 📦 Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/travel-journal.git
   cd travel-journal

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

   * Add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files to the respective directories.
   * Update the Firebase rules for Firestore and Storage as needed.

4. **Run the app:**

   ```bash
   flutter run
   ```

---

## 📁 Folder Structure

```
psckages/
├── auth_repo/
├── auth_ui/
lib/
├── journal/
│   ├── data/          # Data models and repository
│   ├── bloc/          # State management using Bloc
│   ├── presentation/  # UI components and pages
├── map/               # Map-related services
├── routes/            # App routing configuration
├── shared/            # Shared utilities and components
```

---

## 🔑 Key Dependencies

* `firebase_auth`: For user authentication
* `cloud_firestore`: For storing journal data
* `firebase_storage`: For uploading and retrieving images
* `flutter_bloc`: For state management
* `google_maps_flutter`: For map integration
* `dropdown_search`: For country selection
* `shared_preferences`: For local storage

---

## 📝 Usage

### ➕ Adding a Journal

* Navigate to the "Add Journal" page by tapping the "+" icon on the home screen.
* Fill in the required fields: place name, mood, notes, and budget.
* Optionally, upload an image and mark the location as visited.
* Tap **Save** to upload the journal to Firebase.

### ✏️ Viewing and Editing Journals

* Tap on a journal from the feed to view its details.
* Use the **Edit** button to update information.

### 🗺️ Map View

* Access the **Map View** to see all visited locations plotted on a map.

---

## 🔧 Firebase Configuration

Ensure your Firebase project is set up with:

* **Firestore**: For storing journal data
* **Storage**: For uploading and retrieving images
* **Authentication**: For user login and registration

Update the `pubspec.yaml` file with the required Firebase dependencies.

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Commit your changes and push to your fork
4. Submit a pull request

---

## 📜 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## 📸 Screenshots

SignIn

![ss6](ss6.png)

Login

![ss1](ss1.png)

Map View 

![ss2](ss2.png)

Journal Details

![ss3](ss3.png)

Add Journal

![ss4](ss4.png)

Edit Journal

![ss7](ss7.png)

Signout

![ss8](ss8.png)

---

## 📚 Resources

* [Flutter Documentation](https://docs.flutter.dev)
* [Firebase Documentation](https://firebase.google.com/docs)
* [Bloc Library](https://bloclibrary.dev)

For any issues or questions, feel free to open an issue in the repository.

```
