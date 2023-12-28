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

    var completion: ((UIImage) -> Void)?
    let operationQueue = OperationQueue()
    let urlCache = URLCache.shared

    override func main() {
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        operationQueue.qualityOfService = .userInitiated
        operationQueue.isSuspended = true
        operationQueue.maxConcurrentOperationCount = imageURLs.count

        for url in imageURLs {
            guard let safeUrl = URL(string: url) else { continue }

            let request = URLRequest(url: safeUrl)

            if let cachedData = self.urlCache.cachedResponse(for: request)?.data, let cachedImage = UIImage(data: cachedData) {
                print("cached")
                self.completion?(cachedImage)
            } else {
                operationQueue.addOperation {
                    urlSession.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }

                        if let data = data, let response = response, let image = UIImage(data: data) {
                            let cachedData = CachedURLResponse(response: response, data: data)
                            self.urlCache.storeCachedResponse(cachedData, for: request)
                            print("no cache")
                            self.completion?(image)
                        }
                    }.resume()
                }
                operationQueue.isSuspended = false
                operationQueue.waitUntilAllOperationsAreFinished()
            }
        }
    }
}
