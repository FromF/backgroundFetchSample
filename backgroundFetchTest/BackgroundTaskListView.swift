//
//  BackgroundTaskListView.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import SwiftUI

struct BackgroundTaskListView: View {
    @State private var list: [String] = []
    
    var body: some View {
        VStack {
            List(list, id: \.self) { text in
                Text("\(text)")
                    .contextMenu{
                        Button(action: {
                            UIPasteboard.general.string = text
                        }) {
                            Text("Copy")
                        }
                    }
                    .padding()
            }
            Button(action: {
                list = DataShare.shared.array
            }) {
                Text("Refresh")
            }
        }
        .onAppear {
            list = DataShare.shared.array
        }
    }
}

struct BackgroundTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundTaskListView()
    }
}
