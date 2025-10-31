//
//  WeatherNowApp.swift
//  WeatherNow
//
//  Created by Adrian Felix on 30/10/25.
//

import SwiftUI
import CoreData

@main
struct WeatherNowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
