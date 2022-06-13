//
//  PixaBayData.swift
//  ImageView
//
//  Created by Harish Kumar on 12/06/22.
//

import Foundation

struct PixaBayData: Decodable {
    
    let total: Int64?
    let totalHits: Int64?
    var hits: [PixaBayImageModel]
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalHits
        case hits
    }
    
    init(total: Int64, totalHits: Int64, hits: [PixaBayImageModel]) {
        self.total = total
        self.totalHits = totalHits
        self.hits = hits
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decode(Int64.self, forKey: .total)
        totalHits = try values.decode(Int64.self, forKey: .totalHits)
        hits = try values.decode([PixaBayImageModel].self, forKey: .hits)
    }
    
}
