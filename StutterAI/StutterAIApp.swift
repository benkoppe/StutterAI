//
//  StutterAIApp.swift
//  StutterAI
//
//  Created by Ben K on 10/4/21.
//

import SwiftUI

@main
struct StutterAIApp: App {
    
    init () {
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar().standardAppearance
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
