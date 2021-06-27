//
//  UserViewController.swift
//  vkApp
//
//  Created by Юля on 27.06.21.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    var token = ""
    private var user: [Response] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imageLabel.layer.cornerRadius = 100
        
        getData()
    }
    
    func getData() {
        let token = self.token
        let url = URL(string: "https://api.vk.com/method/users.get?fields=photo_200_orig&access_token=\(token)&v=5.131")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user.response
                print(user)
                print(self.user)
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.setData()
            }
        }.resume()
    }
    
    func setData() {
        self.nameLabel.text = self.user[0].first_name
        self.surnameLabel.text = self.user[0].last_name
        
        if self.user[0].photo_200_orig != nil {
            let image = UIImage(named: "thumbnail")
            let url = URL(string: (self.user[0].photo_200_orig)!)
            let data = try? Data(contentsOf: url!)
            self.imageLabel.image = UIImage(data: (data ?? image?.pngData())!)
        }
    }

}
