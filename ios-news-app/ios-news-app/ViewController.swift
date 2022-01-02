//
//  ViewController.swift
//  ios-news-app
//
//  Created by 이성노 on 2021/12/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    let urlAddress: String = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=e04f901cdac04d3fb0ad64f9aee648db"
    
    var newsData: Array<Dictionary<String, Any>>?
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: urlAddress)!) { data, response, error in
            if let dataJson = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    print(articles)
                    self.newsData = articles
                    DispatchQueue.main.async {
                        self.tableViewMain.reloadData()
                    }
                }
                catch {}
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = newsData {
            return news.count
        } else {
            return 0
        }
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData {
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String {
                    cell.labelText.text = title
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("이건 \(indexPath.row) 입니다.")

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController

        if let news = newsData {
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                    controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
            }
        }
        showDetailViewController(controller, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                if let news = newsData {
                    let indexPath = sender as! IndexPath
                    let row = news[indexPath.row]
                    if let r = row as? Dictionary<String, Any> {
                        if let imageUrl = r["urlToImage"] as? String {
                            controller.imageUrl = imageUrl
                        }
                        if let desc = r["description"] as? String {
                            controller.desc = desc
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        getNews()
    }
}

