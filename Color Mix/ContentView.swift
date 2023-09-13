//
//  ContentView.swift
//  Color Mix
//
//  Created by Apurva H on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isHomePageViewPresented = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Paintbrush")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Color Mix")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Create Perfect Color Mix")
                    .font(.title)
                    .foregroundColor(.white)
                
                Button("Start") {
                        isHomePageViewPresented = true
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $isHomePageViewPresented) {
            HomePageView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
