//
//  PixaBayImageModel.swift
//  ImageView
//
//  Created by Harish Kumar on 12/06/22.
//

import Foundation

struct PixaBayImageModel: Decodable {
    
    var id: Int
    var previewWidth: Int
    var previewHeight: Int
    var webformatWidth: Int
    var webformatHeight: Int
    var imageWidth: Int
    var imageHeight: Int
    var imageSize: Int
    var views: Int
    var downloads: Int
    var collections: Int
    var likes: Int
    var comments: Int
    var user_id: Int

    var pageURL: String
    var type: String
    var tags: String
    var previewURL: String
    var webformatURL: String
    var largeImageURL: String
    var user: String
    var userImageURL: String
    
}
