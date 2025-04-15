//
//  HomeScreen.swift
//  CIS357 Final
//
//  Created by Charles F. Greco on 4/3/25.
//

import SwiftUI

struct HomeScreen: View {
    @State var showContentView = false
    var body: some View {
            ZStack {
                Color.blue.opacity(0.8)
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
                    
                    Button(action: {
                        showContentView = true
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.black)
                    }
                    
                    Text("Tap to play")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.top)
                    }
                
            }.ignoresSafeArea()
            .fullScreenCover(isPresented: $showContentView) {
                ContentView(showContentView: $showContentView)
            }
    }
}

#Preview {
    HomeScreen()
}
