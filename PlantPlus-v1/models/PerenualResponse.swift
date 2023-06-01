//
//  PerenualResponse.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import Foundation
import UIKit

// MARK: - PerenualResponse
struct PerenualResponse: Codable, Hashable {
    var data: [PlantPerenualResponse]?
    var to, per_page, current_page, from, last_page, total: Int?

    enum PerenualKeys: String, CodingKey {
        case data, to
        case per_page
        case current_page
        case from
        case last_page
        case total
    }
    
    init() {
        self.data = nil
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: PerenualKeys.self)
        
        self.data = try dataContainer.decodeIfPresent([PlantPerenualResponse].self, forKey: .data)
    }
}

struct PlantPerenualResponse: Codable, Hashable {
    var id: Int?
    var common_name, watering, cycle: String?
    var scientific_name, other_name, sunlight: [String]?
    var default_image: DefaultImagePerenual?
    var image : UIImage?
    
    init() {
        self.id = nil
        self.common_name = nil
        self.scientific_name = nil
        self.cycle = nil
        self.scientific_name = nil
        self.sunlight = nil
        self.other_name = nil
        self.default_image = nil
        self.image = nil
    }

    enum PlantKeys: String, CodingKey {
        case id
        case common_name
        case scientific_name
        case other_name
        case cycle, watering, sunlight
        case default_image
        case image
        enum DefaultImagePerenualKeys: String, CodingKey {
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
        let container = try decoder.container(keyedBy: PlantKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        
        self.common_name = try container.decodeIfPresent(String.self, forKey: .common_name)
        self.watering = try container.decodeIfPresent(String.self, forKey: .watering)
        self.cycle = try container.decodeIfPresent(String.self, forKey: .cycle)
        
        self.sunlight = try container.decodeIfPresent([String].self, forKey: .sunlight)
        self.scientific_name = try container.decodeIfPresent([String].self, forKey: .scientific_name)
        self.other_name = try container.decodeIfPresent([String].self, forKey: .other_name)
        
        self.default_image = try container.decodeIfPresent(DefaultImagePerenual.self, forKey: .default_image)
    }
}

struct DefaultImagePerenual: Codable, Hashable {
    var image_id, license: Int?
    var license_name: String?
    var license_url: String?
    var original_url, regular_url, medium_url, small_url: String?
    var thumbnail: String?
    
    enum DefaultImagePerenualKeys: String, CodingKey {
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
        let container = try decoder.container(keyedBy: DefaultImagePerenualKeys.self)
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

