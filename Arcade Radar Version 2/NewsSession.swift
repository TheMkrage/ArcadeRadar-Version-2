//
//  NewsSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/6/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewsSession: NSObject {
    static var shared: NewsSession = NewsSession()
    
    private override init() { }
    
    func getNewestNews(completionHandler: @escaping (_ news: [News]) -> Void) {
        var newsArray = [News]()
        let ref = Database.database().reference()
        var count = 0
        ref.child("News").queryOrdered(byChild: "Date").queryLimited(toLast: 5).observe(.childAdded, with: { (snapshot:DataSnapshot) in
            count += 1
            
            if let news = News(snapshot: snapshot) {
                newsArray.insert(news, at: 0)
            }
            if count == 5 {
                completionHandler(newsArray)
            }
        }, withCancel: nil)
    }
}
