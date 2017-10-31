//
//  NewsViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 6/30/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var articleTextView: UITextView!
    var news: News?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = news?.title {
            self.titleLabel.text = title
        }
        if let article = news?.article {
            self.articleTextView.text = article
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
