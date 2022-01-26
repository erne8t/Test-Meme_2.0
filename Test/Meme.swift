//
//  Meme.swift
//  MemeMe_1.0
//
//  Created by Yiling Zhang on 1/12/22.
//

import Foundation
import UIKit

// define Meme structure
struct Meme {
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
}

extension Meme {
    
    static var localMemes: [Meme] {
        
        var memeArray = [Meme]()
        for m in Meme.localMemeData() {
            memeArray.append(Meme(topText: nil, bottomText: nil, originalImage: nil, memedImage: m))
        }
        return memeArray
    }
    
    static func localMemeData() -> [UIImage?] {
        
        return [
            UIImage(named: "Meme1"),
            UIImage(named: "Meme2"),
            UIImage(named: "Meme3"),
            UIImage(named: "Meme4"),
            UIImage(named: "Meme5"),
            UIImage(named: "Meme6")
        ]
        
    }
    
}
