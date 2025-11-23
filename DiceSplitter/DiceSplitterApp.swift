//
//  DiceSplitterApp.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftData
import SwiftUI

@main
struct DiceSplitterApp: App {
    @State private var audio = Audio()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(audio)
        .modelContainer(for: Statistics.self)
    }
}
