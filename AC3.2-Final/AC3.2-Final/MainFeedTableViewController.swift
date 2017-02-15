//
//  MainFeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Annie Tung on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class MainFeedTableViewController: UITableViewController {
    
    var databaseRef: FIRDatabaseReference!
    var feeds = [Feed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseRef = FIRDatabase.database().reference().child("posts")
        self.navigationItem.title = "Unit6Final-staGram"
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFeed()
    }
    
    func loadFeed() {
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var newFeed = [Feed]()
            
            for child in snapshot.children {
                //                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String] {
                    let feed = Feed(key: snap.key, uid: valueDict["uid"] ?? "", comment: valueDict["comment"] ?? "")
                    newFeed.append(feed)
                }
            }
            self.feeds = newFeed
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! MainFeedTableViewCell
        
        let feed = feeds[indexPath.row]
        cell.commentLabel.text = feed.comment
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(feed.key)")
        
        spaceRef.data(withMaxSize: 1 * 800 * 800) { (data, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    cell.feedImage?.image = UIImage(data: data)
                    cell.layoutIfNeeded()
                }
            }
        }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
