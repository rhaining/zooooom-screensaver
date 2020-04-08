//
//  ConfigFetcher.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct ConfigFetcher {
    static func fetch(completion: @escaping (_ data: Config?, _ error: Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "https://zooooom.us/config.json")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                let config: Config?
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    config = try decoder.decode(Config.self, from: data)
                } catch {
                    NSLog("error = \(error)")
                    config = nil
                }
                
                DispatchQueue.main.async {
                    completion(config, nil)
                }

            }
            task.resume()
        }
    }
}
