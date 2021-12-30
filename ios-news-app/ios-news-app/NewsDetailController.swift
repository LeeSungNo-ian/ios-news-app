//
//  NewsDetailController.swift
//  ios-news-app
//
//  Created by 이성노 on 2021/12/28.
//

import UIKit

class NewsDetailController: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = imageUrl {
            if let data = try? Data(contentsOf: URL(string: img)!) {
                DispatchQueue.main.async {
                    self.mainImage.image = UIImage(data: data)
                }
            }
        }
        
        if let des = desc {
            self.mainLabel.text = des
        }
    }
}

