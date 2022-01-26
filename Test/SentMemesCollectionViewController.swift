//
//  MemeCollectionViewController.swift
//  MemeMe_2.0
//
//  Created by Yiling Zhang on 1/18/22.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // get memes from AppDelegate
    var memes: [Meme]! {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        // To make flowLayout actually work, go to Main -> Flow Layout. In "Show the Size inspector", make "Estimate Size" -> "None"
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell

        cell.sentMemeImageView?.image = self.memes[(indexPath as NSIndexPath).row].memedImage
        return cell
    }
    
    // when clicked, push to MemeDetailViewController
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
