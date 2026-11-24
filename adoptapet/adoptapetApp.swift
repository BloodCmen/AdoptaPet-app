
import SwiftUI
import FirebaseCore

@main
struct adoptapetApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
