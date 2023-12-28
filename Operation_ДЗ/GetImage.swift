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
    
    private let imageURLs = [
        "https://www.nastol.com.ua/pic/201509/1920x1200/nastol.com.ua-150653.jpg",
        "https://onn.az/wp-content/uploads/2021/06/sagzh-1920x1280-1.jpg",
        "https://static.slobodnadalmacija.hr/images/slike/2023/01/12/24127418.jpg",
        "https://content.assets.pressassociation.io/2017/07/18153241/17_7_5_WildcatKitten_SA_11.jpg",
        "https://www.cestujlevne.com/obrazky/70/12/17012-2160w.jpg",
        "https://mykaleidoscope.ru/x/uploads/posts/2022-09/1663091157_62-mykaleidoscope-ru-p-gollandiya-vkontakte-68.jpg",
        "https://bonpic.com/download_img.php?dimg=5286&raz=1280x1024"
    ]
    
    var completion: ((UIImage?) -> Void)?
    let operationQueue = OperationQueue()
    let cache = NSCache<NSString, UIImage>()
    
    override func main() {
        operationQueue.qualityOfService = .utility
        operationQueue.maxConcurrentOperationCount = imageURLs.count
        
        for url in imageURLs {
            
            if let cachedImage = cache.object(forKey: url as NSString) {
                print(cachedImage)
                DispatchQueue.main.async {
                    self.completion?(cachedImage)
                }
            } else {
                
                guard let safeUrl = URL(string: url) else { return }
                
                operationQueue.addOperation {
                    if let data = try? Data(contentsOf: safeUrl),
                       let image = UIImage(data: data) {
                        print("downloading")
                        self.cache.setObject(image, forKey: url as NSString)
                        
                        DispatchQueue.main.async {
                            self.completion?(image)
                        }
                    }
                }
            }
        }
    }
}
