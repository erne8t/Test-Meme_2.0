//
//  SentMemesTableViewController.swift
//  Test
//
//  Created by Yiling Zhang on 1/19/22.
//

import UIKit

// Use UITableViewController instead of UIViewController + UITableViewDelegate & UITableViewDataSource
class SentMemesTableViewController: UITableViewController {

    // get memes from AppDelegate
    var memes: [Meme]! {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell")!
        let sentMeme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = (sentMeme.topText ?? "") + " " + (sentMeme.bottomText ?? "")
        cell.imageView?.image = sentMeme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memeImage = self.memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    // In Main, select the NavigationBar, change Navigation Item's "Title" to "Sent Memes"
    
    @IBAction func addNewMeme(_ sender: Any) {
        let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(memeEditorViewController, animated: true)
    }
}
