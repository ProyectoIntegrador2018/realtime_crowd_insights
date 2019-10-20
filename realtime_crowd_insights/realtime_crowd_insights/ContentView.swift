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
    @State private var showImagePicker: Bool = true
    @State private var image: Image? = nil
 
    var body: some View {
        TabView(selection: $selection){
            HistorialView()
                .tabItem {
                    VStack {
                        Image("history_icon")
                        Text("History")
                    }
                }
                .tag(0)
            CameraView()
                .tabItem {
                    VStack {
                        Image("camera_icon")
                        Text("Camera")
                    }
                }

                .tag(1)
            PhotosView()
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

