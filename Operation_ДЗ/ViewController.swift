//
//  ViewController.swift
//  Operation_ДЗ
//
//  Created by Илья Кузнецов on 27.12.2023.
//

import UIKit

class ViewController: UIViewController {

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
        //operationQueue()
        
        GetImage.shared.completion = { image in
            self.imagesArray.append(image)
        }
        GetImage.shared.start()
    }
    
//    private func operationQueue() {
//        let getImage = GetImage()
//        getImage.queuePriority = .veryHigh
//        getImage.qualityOfService = .userInitiated
//        getImage.completion = { image in
//            self.imagesArray.append(image)
//            print(self.imagesArray.count)
//        }
//        getImage.start()
//    }
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
        cell.imageView?.image = imagesArray[indexPath.row]
        return cell
    }
    
}

