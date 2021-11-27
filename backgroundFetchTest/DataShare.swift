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
    
    // URLSessionのバックグラウンド実行用の識別子
    private let identifier: String = "DataShareOperation"

    private func add(_ text: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let dateString = dateFormatter.string(from: Date())

        array.append("\(dateString) \(text)")
        debugLog("add:\(dateString) \(text)")
    }
    
    func post(kind: String , gps: String = "" , speed: String = "" , steps: String = "" , call: String = "", charge: String = "", music: String = "", systemUpTime: String = "") {
        //Googleスプレットシートのスクリプトをデプロイした後に発行されるURLを入力してください
        let url = ""
        
        let params: [String : Any] = [
            "name" : UIDevice.current.name,
            "kind" : kind,
            "gps": gps,
            "speed": speed,
            "steps": steps,
            "call": call,
            "charge": charge,
            "music": music,
            "systemUpTime": systemUpTime,
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        urlRequest.httpBody = body
        
        // バックグラウンド用セッションの作成
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        // OSのタイミングに任せない(false)
        configuration.isDiscretionary = false

        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

        let task = session.downloadTask(with: urlRequest)
        task.resume()
        add("\(kind):\(params)")
    }
}

extension DataShare : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        session.finishTasksAndInvalidate()
        debugLog("complete")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            errorLog(error.localizedDescription)
        }
        session.finishTasksAndInvalidate()
    }
}
