//
//  HomeScreen.swift
//  CIS357 Final
//
//  Created by Charles F. Greco on 4/3/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView{
            
            ZStack {
                Color.blue.opacity(0.8)
                VStack{
                    NavigationLink(destination: ContentView()){
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
                        .navigationTitle("Number Drawer")

                }
            }.ignoresSafeArea()
        }
        
    }
}

#Preview {
    HomeScreen()
}
