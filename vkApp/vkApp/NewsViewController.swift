//
//  NewsViewController.swift
//  vkApp
//
//  Created by Юля on 27.06.21.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var token = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("Token")
        print(token)
        
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: indexPath)
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
            
           // let json = try? JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            let response = try? decoder.decode(FeedResponce.self, from: data)
            print(response)
            
        }
    }

}
