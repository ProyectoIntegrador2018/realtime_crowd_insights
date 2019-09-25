//
//  ContentView.swift
//  realtime_crowd_insights
//
//  Created by Miguel Bazán on 9/23/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//  Icons obtained from: http://www.iconbeast.com/

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("History Tab")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("history_icon")
                        Text("History")
                    }
                }
                .tag(0)
            Text("Camera")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("camera_icon")
                        Text("Camera")
                    }
                }
                .tag(1)
            Text("Photos")
            .font(.title)
            .tabItem {
                VStack {
                    Image("photos_icon")
                    Text("Photos")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
