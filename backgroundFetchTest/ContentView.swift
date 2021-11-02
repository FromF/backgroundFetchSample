//
//  ContentView.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var list: [String] = []
    
    var body: some View {
        TabView {
            StatusView()
                .padding(.bottom)
                .tabItem {
                    Text("ステータス")
                }
                .tag(0)
            
            BackgroundTaskListView()
                .padding(.bottom)
                .tabItem {
                    Text("バックグラウンドログ")
                }
                .tag(1)
        }
        .onAppear {
            let _ = StepManager.shared
            let _ = LocationManager.shared
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
