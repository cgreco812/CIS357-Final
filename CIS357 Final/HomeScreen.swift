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
        NavigationView{
            
            ZStack {
                Color.blue.opacity(0.8)
                VStack{
                   // NavigationLink(destination: ContentView()){
                    Button(action: {
                        showContentView = true
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 2.0)
                    
                    Text("Tap to play")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.top)
                    }
                
                        

               // }
                //.navigationTitle("Number Drawer")
            }.ignoresSafeArea().fullScreenCover(isPresented: $showContentView) {
                ContentView()
            }
        }
        
    }
}

#Preview {
    HomeScreen()
}
