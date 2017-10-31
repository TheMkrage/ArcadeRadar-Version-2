//
//  CommentsViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/5/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Presentr

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddCommentDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isDisplayingAnArcade() {
            let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
            self.nameLabel.text = arcade.name
            self.comments = arcade.comments ?? []
        } else {
            let machine = (self.tabBarController as! MachineTabViewController).machine!
            self.nameLabel.text = machine.name
            self.comments = machine.comments ?? []
        }
        
        self.view.addBlurEffect()
        self.view.layer.cornerRadius = 25.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.comments.sort { (c1, c2) -> Bool in
            return c1.createdAt ?? Date.distantPast > c2.createdAt ?? Date.distantPast
        }
        if self.comments.isEmpty {
            self.tableView.isHidden = true
            self.noCommentsLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.noCommentsLabel.isHidden = true
        }
    }
    
    @IBAction func addCommentPressed(_ sender: Any) {
        /*// if no account, show signup
        guard UserSession.shared.hasAccountMade() else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "signup") as? SignupViewController else {
                return
            }
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            return
        }*/
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddComment") as? AddCommentViewController else {
            return
        }
        vc.delegate = self
        let presentr = Presentr(presentationType: .custom(width: .fluid(percentage: 0.85), height: .fluid(percentage: 0.48), center: .topCenter))
        self.customPresentViewController(presentr, viewController: vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = self.comments[indexPath.row]
        cell.usernameLabel.text = comment.title
        cell.dataLabel.text = comment.createdAt?.getFormattedDate()
        cell.textView.text = comment.comment
        return cell
    }
    func commentEditingDidEndEditing(withTitle: String, text: String) {
        var item: RateableLocation
        if isDisplayingAnArcade() {
            item = (self.tabBarController as! ArcadeTabViewController).arcade!
        } else {
            item = (self.tabBarController as! MachineTabViewController).machine!
        }
        let comment = Comment()
        comment.comment = text
        comment.title = withTitle
        //comment.index = self.comments.count
        comment.createdAt = Date()
        /*guard let username = UserSession.shared.username else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "signup") as? SignupViewController else {
                return
            }
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            return
        }
        comment.creatorUsername = username*/
        CommentSession.shared.save(comment: comment, isArcade: self.isDisplayingAnArcade(), locationId: item.objectId)
        self.comments.append(comment)
        self.comments.sort { (c1, c2) -> Bool in
            return c1.createdAt ?? Date.distantPast > c2.createdAt ?? Date.distantPast
        }
        if self.comments.isEmpty {
            self.tableView.isHidden = true
            self.noCommentsLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.noCommentsLabel.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    func isDisplayingAnArcade() -> Bool {
        return (self.tabBarController as? ArcadeTabViewController) != nil
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeArcadeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
