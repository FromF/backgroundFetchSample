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
        VStack {
            List(list, id: \.self) { text in
                Text("\(text)")
                    .padding()
            }
            Button(action: {
                
                list = DataShare.shared.array
                
            }) {
                Text("Reload")
            }
        }
        .onAppear {
            let _ = LocationManager.shared
            let _ = StepManager.shared
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
