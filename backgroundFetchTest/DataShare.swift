//
//  DataShare.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import UIKit

class DataShare: NSObject {
    static let shared = DataShare()
    
    private (set) public var array: [String] = []
    
    func add(_ text: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let dateString = dateFormatter.string(from: Date())

        array.append("\(dateString) \(text)")
        print("add:\(dateString) \(text)")
    }
}
