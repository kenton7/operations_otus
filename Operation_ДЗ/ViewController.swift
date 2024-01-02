import UIKit

final class ViewController: UIViewController {
    
    private let imageURLs = [
        "https://www.nastol.com.ua/pic/201509/1920x1200/nastol.com.ua-150653.jpg",
        "https://onn.az/wp-content/uploads/2021/06/sagzh-1920x1280-1.jpg",
        "https://static.slobodnadalmacija.hr/images/slike/2023/01/12/24127418.jpg",
        "https://content.assets.pressassociation.io/2017/07/18153241/17_7_5_WildcatKitten_SA_11.jpg",
        "https://www.cestujlevne.com/obrazky/70/12/17012-2160w.jpg",
        "https://mykaleidoscope.ru/x/uploads/posts/2022-09/1663091157_62-mykaleidoscope-ru-p-gollandiya-vkontakte-68.jpg",
        "https://bonpic.com/download_img.php?dimg=5286&raz=1280x1024",
        "https://wallbox.ru/resize/1600x1200/wallpapers/main2/201744/150962391459fb086aa45c62.75954367.jpg",
        "https://c.wallhere.com/photos/71/aa/bridge_rocks_river_city_city_on_the_water_reflection-1059630.jpg!d",
        "https://w.forfun.com/fetch/00/00dc65cb928157c9552569c7e959d40c.jpeg?w=1470&r=0.5625",
        "https://images.hdqwalls.com/download/columbia-lake-2048x1152.jpg"
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
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.cellID)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        DownloadImage.shared.start()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellID, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if let url = URL(string: imageURLs[indexPath.row]) {
            cell.customImageView.loadImage(url)
        }
        return cell
    }
}

