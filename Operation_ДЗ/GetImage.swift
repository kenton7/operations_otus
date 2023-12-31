//
//  GetImage.swift
//  Operation_ДЗ
//
//  Created by Илья Кузнецов on 27.12.2023.
//

import Foundation
import UIKit

class GetImage: Operation {
    
    static let shared = GetImage()
    
    private override init() {}
    
    var completion: ((UIImage, String) -> Void)?
    let operationQueue = OperationQueue()
    let cache = NSCache<NSString, UIImage>()
    
    func start(url: String) {
         operationQueue.qualityOfService = .utility
         operationQueue.maxConcurrentOperationCount = 4
         guard let safeUrl = URL(string: url) else { return }
         let request = URLRequest(url: safeUrl)

         operationQueue.addOperation {
             URLSession.shared.dataTask(with: request) { data, response, error in
                 if let data = data, let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                         let encoded = try! PropertyListEncoder().encode(data)
                         UserDefaults.standard.set(encoded, forKey: url)
                         print(url)
                         self.completion?(image, url)
                     }
                 }
             }.resume()
         }
     }
}
