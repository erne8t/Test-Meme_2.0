//
//  MemeDetailViewController.swift
//  Test
//
//  Created by Yiling Zhang on 1/21/22.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView?.image = memeImage
    }
}
