//
//  HomeScreen.swift
//  CIS357 Final
//
//  Created by Charles F. Greco on 4/3/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Blue background
                Color.blue.opacity(0.8).ignoresSafeArea()
                
                VStack(spacing: 35) {
                    // Welcome title
                    VStack {
                        Text("Welcome to")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        Text("NUMBER DRAWER")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    
                    // Play button with navigation
                    NavigationLink(destination: ContentView()) {
                        VStack {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                            
                            Text("Tap to play")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                        }
                    }
                }
                .padding(.bottom, 60) // Push content up slightly
            }
            .navigationTitle("Number Drawer")
            .navigationBarHidden(true) // Hide navigation bar for cleaner home screen
        }
    }
}

#Preview {
    HomeScreen()
}
