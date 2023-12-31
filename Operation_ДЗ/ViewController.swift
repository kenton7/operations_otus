//
//  ViewController.swift
//  Operation_ДЗ
//
//  Created by Илья Кузнецов on 27.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageURLs = [
        "https://www.nastol.com.ua/pic/201509/1920x1200/nastol.com.ua-150653.jpg",
        "https://onn.az/wp-content/uploads/2021/06/sagzh-1920x1280-1.jpg",
        "https://static.slobodnadalmacija.hr/images/slike/2023/01/12/24127418.jpg",
        "https://content.assets.pressassociation.io/2017/07/18153241/17_7_5_WildcatKitten_SA_11.jpg",
        "https://www.cestujlevne.com/obrazky/70/12/17012-2160w.jpg",
        "https://mykaleidoscope.ru/x/uploads/posts/2022-09/1663091157_62-mykaleidoscope-ru-p-gollandiya-vkontakte-68.jpg",
        "https://bonpic.com/download_img.php?dimg=5286&raz=1280x1024"
    ]

    private var imagesArray = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        imageURLs.forEach { url in
            if let data = UserDefaults.standard.data(forKey: url) {
                let decodedData = try! PropertyListDecoder().decode(Data.self, from: data)
                if let image = UIImage(data: decodedData) {
                    print("Get image from Cache")
                    self.imagesArray.append(image)
                }
            } else {
                GetImage.shared.completion = { image, url in
                    print("downloading image")
                    self.imagesArray.append(image)
                }
                GetImage.shared.start(url: url)
            }
        }

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            cell.imageView?.image = self.imagesArray[indexPath.row]
        }
        return cell
    }
}

