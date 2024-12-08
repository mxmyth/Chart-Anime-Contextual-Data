//
//  Chart_Anime_Contextual_DataApp.swift
//  Chart Anime Contextual+Data
//
//  Created by Mario Tetelepta  on 12/5/24.
//

import SwiftUI
import SwiftData

@main
struct Chart_Anime_Contextual_DataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PieChartView()
        }
        .modelContainer(sharedModelContainer)
    }
}
