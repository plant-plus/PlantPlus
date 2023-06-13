//
//  DataDiseases.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import Foundation
import UIKit

struct Disease: Codable, Hashable {
    var id: Int?
    var common_name, scientific_name, family, description, solution: String?
    var other_name, host: [String]?
    var images: [Image]?
    var image : UIImage?
    
    init() {
        self.id = nil
        self.common_name = nil
        self.scientific_name = nil
        self.family = nil
        self.description = nil
        self.solution = nil
        self.other_name = nil
        self.host = nil
        self.images = nil
        self.image = nil
    }
    
    enum DiseaseObjectKeys: String, CodingKey {
        case id
        case common_name
        case scientific_name
        case family
        case description
        case solution
        case other_name
        case host
        case images
        case image

        enum DefaultImageKeys: String, CodingKey {
            case license_name
            case original_url
            case regular_url
            case medium_url
            case small_url
            case thumbnail
        }
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DiseaseObjectKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.common_name = try container.decodeIfPresent(String.self, forKey: .common_name)
        self.scientific_name = try container.decodeIfPresent(String.self, forKey: .scientific_name)
        self.family = try container.decodeIfPresent(String.self, forKey: .family)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.solution = try container.decodeIfPresent(String.self, forKey: .solution)
        
        self.other_name = try container.decodeIfPresent([String].self, forKey: .other_name)
        self.host = try container.decodeIfPresent([String].self, forKey: .host)
        
        self.images = try container.decodeIfPresent([Image].self, forKey: .images)
    }
}

struct DataDiseases: Codable, Hashable {
    var data: [Disease]?
    var to, perPage, currentPage, from, lastPage, total: Int?
    
    init() {
        self.data = nil
    }
    
    enum DataDiseaseKeys: String, CodingKey {
        case data, to
        case perPage
        case currentPage
        case from
        case lastPage
        case total
        
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataDiseaseKeys.self)
        
        self.data = try dataContainer.decodeIfPresent([Disease].self, forKey: .data)
    }
}



struct Image: Codable, Hashable {
    var license: Int?
    var license_name: String?
    var license_url: String?
    var original_url, regular_url, medium_url, small_url: String?
    var thumbnail: String?

    enum ImageCodingKeys: String, CodingKey {
        case license
        case license_name
        case license_url
        case original_url
        case regular_url
        case medium_url
        case small_url
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageCodingKeys.self)
        self.license = try container.decodeIfPresent(Int.self, forKey: .license)
        self.license_name = try container.decodeIfPresent(String.self, forKey: .license_name)
        self.license_url = try container.decodeIfPresent(String.self, forKey: .license_url)
        self.original_url = try container.decodeIfPresent(String.self, forKey: .original_url)
        self.regular_url = try container.decodeIfPresent(String.self, forKey: .regular_url)
        self.medium_url = try container.decodeIfPresent(String.self, forKey: .medium_url)
        self.small_url = try container.decodeIfPresent(String.self, forKey: .small_url)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
    }
}



