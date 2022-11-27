//
//  KnapsackAppApp.swift
//  KnapsackApp
//
//  Created by Rafał on 24/11/2022.
//

import SwiftUI

@main
struct KnapsackAppApp: App {
    
    @StateObject var appVM = AppVM()
    
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(appVM)
        }
    }
}
