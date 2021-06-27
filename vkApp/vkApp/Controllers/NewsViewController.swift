//
//  NewsViewController.swift
//  vkApp
//
//  Created by Юля on 27.06.21.
//

import UIKit

class NewsViewController: UIViewController {
    
    var token = ""
    private var news: [FeedItem] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.rowHeight = 400
        
        getData()
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = "5.131"
        
        let url = self.url(from: path, params: allParams)
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {(data, responce, error) in
            DispatchQueue.main.async {
                completion(data, error)
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    private func url(from path: String, params: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        print(components.url)
        return components.url!
    }
    
    func getData() {
        let params = ["filters": "post, photo"]
        request(path: "/method/newsfeed.get", params: params) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else { return }

            let response = try? decoder.decode(FeedResponce.self, from: data)
            self.news = (response?.response.items)!
            print(self.news)
        }
    }
    
}

extension NewsViewController: UITableViewDelegate {
    
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = news[indexPath.row].text
        cell.likesLabel.text = String(news[indexPath.row].likes!.count)
        
        if news[indexPath.row].attachments?.count != 0 && news[indexPath.row].attachments![0].type == "photo" {
            let image = UIImage(named: "thumbnail")
            let url = URL(string: (news[indexPath.row].attachments![0].photo?.sizes![0].url)!)
            let data = try? Data(contentsOf: url!)
            cell.imageLabel.image = UIImage(data: (data ?? image?.pngData())!)
            
        }
        return cell
    }
}

