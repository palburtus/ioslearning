//
//  ViewController.swift
//  newsreader
//
//  Created by Alburtus, Patrick on 5/9/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var newsItems = [NewsItem]()
    private var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self;
        
        self.fetchNews()
        
        self.title = "Select Specialty"
    }

        
    func fetchNews()  {
        
        let url = URL(string: "https://img.staging.medscape.com/pi/iphone/testassets/sampleData.json")
        
        URLSession.shared.dataTask(with: url!) { [weak self](data, response, error) in
            if let data = data {
                guard let newsDto = try? JSONDecoder().decode(NewsDto.self, from: data) else {
                    fatalError("fetching news failed with error \(String(describing: error))")
                }
                
                self?.newsItems.append(contentsOf: newsDto.items)
            }
            self?.isLoading = false
        }.resume()
        
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print("tap")
     
        //This is how to do it programitcally insted of segweay through storyboard
        //TODO add guard
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
        detailsViewController.title = newsItems[indexPath.row].title
        detailsViewController.modalPresentationStyle = .fullScreen
        self.present(detailsViewController, animated: true, completion: nil)
        
        /*
         
        guard let storyboard = storyboard(), let vc = storyboard.  storyboard.instantiateViewController(identifier: "details") else {
                   fatalError("Failed to initialize WBMDAdDebug.storyboard")
               }

               vc.modalPresentationStyle = .fullScreen
               viewController.present(vc, animated: true, completion: nil)    }
         
         private static func storyboard() -> UIStoryboard? {
             UIStoryboard(name: "WBMDAdDebug", bundle: Bundle.adDebugResourceBundle)
         }
         */
         
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
          return 1
        } else {
            return newsItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        if(isLoading){
            cell.textLabel?.text = ""
        }else{
            let item = newsItems[indexPath.row]
            cell.textLabel?.text = item.title
        }
        return cell
    }
}




