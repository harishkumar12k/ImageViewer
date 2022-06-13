//
//  PixaBayCollectionCell.swift
//  ImageView
//
//  Created by Harish Kumar on 13/06/22.
//

import UIKit
import Alamofire

class PixaBayCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
