//
//  NewsViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 6/30/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewsMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet var table: UITableView!
    var news: [News?] = [News?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        
        self.mapsButton.backgroundColor = Colors.yesColor
        self.browseButton.backgroundColor = Colors.yesColor
        self.mapsButton.titleLabel?.addTextSpacing()
        self.browseButton.titleLabel?.addTextSpacing()
        self.mapsButton.layer.cornerRadius = 15
        self.browseButton.layer.cornerRadius = 15
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(profileSelected))
        // load news cell nib into table
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "news")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let progress = JGProgressHUD(style: .extraLight)
        progress?.show(in: self.table)
        NewsSession.shared.getNewestNews(completionHandler: { (news: [News]) in
            progress?.dismiss()
            self.news = news
            self.table.reloadData()
        })
    }

    /*func profileSelected() {
        if UserSession.shared.hasAccountMade() {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {
                return
            }
            vc.userId = UserSession.shared.userId
            self.show(vc, sender: self)
        } else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "signup") as? SignupViewController else {
                return
            }
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        }
    }*/

    // MARK: - Table D's
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "news") as! NewsViewController
        vc.news = self.news[indexPath.row]
        if vc.news?.title != " " {
            self.show(vc, sender: self)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! NewsTableViewCell
        cell.titleLabel.text = news[indexPath.row]?.title
        cell.descriptionView.text = news[indexPath.row]?.description

        return cell
    }

}
