//
//  ImageDetailView.swift
//  ImageView
//
//  Created by Harish Kumar on 13/06/22.
//

import Foundation
import UIKit
import Alamofire

class ImageDetailView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var pixaBayImageData: PixaBayImageModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userLabel.text = pixaBayImageData.user
        self.resolutionLabel.text = "\(pixaBayImageData.imageWidth)x\(pixaBayImageData.imageHeight)"
        self.loadImage(url: pixaBayImageData.largeImageURL)
        self.tags.text = pixaBayImageData.tags
        imageView.addGradientForLikes()
        self.likesLabel.text = "♥ \((self.pixaBayImageData.likes as NSNumber).stringValue)"
        self.viewWillLayoutSubviews()
    }

    func loadImage(url: String){
        print(url)
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseData { response in
                self.imageView.image = UIImage(data: response.data!)
            }
    }
    
}
