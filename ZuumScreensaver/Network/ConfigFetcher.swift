//
//  ConfigFetcher.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct ConfigFetcher {
    static private func getURL() -> URL? {
        if let urlString = Bundle(for: ZuumScreensaverView.self).object(forInfoDictionaryKey: "RTHZooooomConfigURLString") as? String,
            let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }

    }
    static func fetch(completion: @escaping (_ data: Config?, _ error: Error?) -> Void) {
        guard let url = getURL() else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        DispatchQueue.global(qos: .background).async {
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
