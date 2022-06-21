//
//  ViewController.swift
//  ImageView
//
//  Created by Harish Kumar on 09/06/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchImageBar: UISearchBar!
    
    var page = 1
    var pixaBayImageSets: [PixaBayImageModel] = []
    var cacheImages: [String: Data] = [:]
    var key = "27933600-0d42f2ac5afa15c761e311cce"
    var searchImagesString = "apple"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "PixaBayCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PixaBayCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        searchImageBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPixaBayimageSets()
    }
    
    /**
        Get all the image Sets from the link
     */
    func getPixaBayimageSets()  {
        
        if searchImagesString == "" {
            let alert = UIAlertController(title: "Text Required", message: "Search bar should not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let pixabayEndPoint: String = "https://pixabay.com/api/?key=\(key)&q=\(searchImagesString)&image_type=photo&per_page=50&page=\(page)"
        
        AF.request(pixabayEndPoint, method: .get, encoding: JSONEncoding.default)
            .responseData { [self] response in
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    do{
                        var pixaBayData: PixaBayData?
                        var maxImageSets: Int64 = 0
                        pixaBayData = try JSONDecoder().decode(PixaBayData.self, from: data)
                        if (pixaBayData?.totalHits != nil && pixaBayData!.totalHits! > 0) {
                            maxImageSets = pixaBayData!.totalHits!
                            if pixaBayImageSets.count < maxImageSets {
                                pixaBayImageSets.append(contentsOf: pixaBayData?.hits ?? [])
                                self.collectionView.reloadData()
                            }
                        }
                    }catch{
                        print("error: \(error)")
                    }
                case .failure(let error):
                    print(response, error)
                }
            }
    }
    
    /**
        Returns the size of every collection cells
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (collectionView.frame.width-20)/3
        return CGSize(width: width, height: width)
    }
    
    /**
        Returns the Number of cells for collectionView, varies with set of images
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixaBayImageSets.count
    }
    
    /**
        Returns the cells with breif information
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixaBayCollectionCell", for: indexPath) as! PixaBayCollectionCell
        DispatchQueue.main.async {
            self.startLoader(cell: cell)
            cell.idLabel.text = "♥ \((self.pixaBayImageSets[indexPath.row].likes as NSNumber).stringValue)"
            cell.gradientView.addGradientForLikes()
            self.loadImage(cell: cell, url: self.pixaBayImageSets[indexPath.row].previewURL)
        }
        return cell
    }
    
    /**
        Present the detail screen of selected image
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ImageDetailView") as! ImageDetailView
        nextViewController.pixaBayImageData = self.pixaBayImageSets[indexPath.row]
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    /**
        Call the API once end of screen reached
     */
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == pixaBayImageSets.count - 1 ) {
             page += 1
             self.getPixaBayimageSets()
         }
    }
    
    /**
        Download the images
     */
    func loadImage(cell: PixaBayCollectionCell, url: String){
        print(url)
        if cacheImages.keys.contains(url) {
            cell.imageView.image = UIImage(data: cacheImages[url]!)
            self.stopLoader(cell: cell)
        } else {
            cell.imageView.image = nil
            AF.request(url, method: .get, encoding: JSONEncoding.default)
                .responseData { response in
                    self.cacheImages[url] = response.data!
                    cell.imageView.image = UIImage(data: response.data!)
                    self.stopLoader(cell: cell)
                }
        }
    }
    
    /**
        Start the animating Loader
     */
    func startLoader(cell: PixaBayCollectionCell) {
        cell.isHidden = false
        cell.loader.startAnimating()
    }
    
    /**
        Stop the Loader
     */
    func stopLoader(cell: PixaBayCollectionCell) {
        cell.loader.stopAnimating()
        cell.loader.isHidden = true
    }
    
}

extension ViewController {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchImagesString
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text == searchImagesString {
            return
        }
        if let searchText = searchBar.text {
            searchImagesString = searchText.components(separatedBy: .whitespaces).filter { !$0.isEmpty }.joined(separator: " ")
            print("searchImagesString :: \(searchImagesString)")
            resetCells()
            getPixaBayimageSets()
        }
    }
    
    func resetCells() {
        page = 1
        pixaBayImageSets = []
        cacheImages = [:]
        collectionView.reloadData()
    }
    
}

extension UIView {
    
    func addGradientForLikes() {
        if self.layer.sublayers != nil {
            for subView in self.layer.sublayers! {
                subView.removeFromSuperlayer()
            }
        }
        
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
