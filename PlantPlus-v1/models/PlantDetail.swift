//
//  PlantDetail.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import Foundation
import UIKit

// MARK: - PlantDetail
struct PlantDetail: Codable, Identifiable {
//    var id: UUID?
    var id: Int?
    var common_name: String?
    var family: String?
    var type, dimension, cycle, watering, license_name, original_url, regular_url, medium_url, small_url, thumbnail: String?
    var hardiness: Hardiness?
    var flowers: Bool?
    var scientific_name, other_name, sunlight, leaf_color, fruit_color, soil, origin, attracts, propagation: [String]?
    var cones, fruits, edible_fruit: Bool?
    var growth_rate, maintenance, care_level: String?
    var leaf,drought_tolerant, salt_tolerant, thorny, invasive, tropical, cuisine, indoor, edible_leaf: Bool?
    var default_image: DefaultImage?
    var image : UIImage?
    var min, max: String?
    
    init() {
        self.id = nil
        self.common_name = nil
        self.scientific_name = nil
        self.other_name = nil
        self.family = nil
        self.origin = nil
        self.type = nil
        self.dimension = nil
        self.cycle = nil
        self.watering = nil
        self.attracts = nil
        self.propagation = nil
        self.hardiness = nil
        self.flowers = nil
        self.sunlight = nil
        self.soil = nil
        self.cones = nil
        self.fruits = nil
        self.edible_fruit = nil
        self.fruit_color = nil
        self.leaf = nil
        self.leaf_color = nil
        self.edible_leaf = nil
        self.growth_rate = nil
        self.maintenance = nil
        self.drought_tolerant = nil
        self.salt_tolerant = nil
        self.thorny = nil
        self.invasive = nil
        self.tropical = nil
        self.cuisine = nil
        self.indoor = nil
        self.care_level = nil
        self.default_image = nil
        self.license_name = nil
        self.original_url = nil
        self.regular_url = nil
        self.medium_url = nil
        self.small_url = nil
        self.thumbnail = nil
        self.image = nil
        self.min = nil
        self.max = nil
    }

    enum PlantDetailKeys: String, CodingKey {
        case id
        case common_name
        case scientific_name
        case other_name
        case family, origin, type, dimension, cycle, watering, attracts, propagation, hardiness
        case flowers
        case color, sunlight, soil
        case cones, fruits
        case edible_fruit
        case fruit_color
        case leaf
        case leaf_color
        case edible_leaf
        case growth_rate
        case maintenance
        case drought_tolerant
        case salt_tolerant
        case thorny, invasive
        case tropical, cuisine
        case indoor
        case care_level
        case default_image
        case image
        enum DefaultImageKeys: String, CodingKey {
            case license_name
            case original_url
            case regular_url
            case medium_url
            case small_url
            case thumbnail
        }
        
        enum HardinessKeys: String, CodingKey {
            case min, max
        }
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: PlantDetailKeys.self)
        self.id = try data.decodeIfPresent(Int.self, forKey: .id)
        
        self.flowers = try data.decodeIfPresent(Bool.self, forKey: .flowers)
        self.cones = try data.decodeIfPresent(Bool.self, forKey: .cones)
        self.fruits = try data.decodeIfPresent(Bool.self, forKey: .fruits)
        self.edible_fruit = try data.decodeIfPresent(Bool.self, forKey: .edible_fruit)
        self.leaf = try data.decodeIfPresent(Bool.self, forKey: .leaf)
        self.drought_tolerant = try data.decodeIfPresent(Bool.self, forKey: .drought_tolerant)
        self.salt_tolerant = try data.decodeIfPresent(Bool.self, forKey: .salt_tolerant)
        self.thorny = try data.decodeIfPresent(Bool.self, forKey: .thorny)
        self.invasive = try data.decodeIfPresent(Bool.self, forKey: .invasive)
        self.tropical = try data.decodeIfPresent(Bool.self, forKey: .tropical)
        self.cuisine = try data.decodeIfPresent(Bool.self, forKey: .cuisine)
        self.indoor = try data.decodeIfPresent(Bool.self, forKey: .indoor)
        self.edible_leaf = try data.decodeIfPresent(Bool.self, forKey: .edible_leaf)
        
        self.common_name = try data.decodeIfPresent(String.self, forKey: .common_name)
        self.family = try data.decodeIfPresent(String.self, forKey: .family)
        self.type = try data.decodeIfPresent(String.self, forKey: .type)
        self.dimension = try data.decodeIfPresent(String.self, forKey: .dimension)
        self.growth_rate = try data.decodeIfPresent(String.self, forKey: .growth_rate)
        self.cycle = try data.decodeIfPresent(String.self, forKey: .cycle)
        self.watering = try data.decodeIfPresent(String.self, forKey: .watering)
        self.maintenance = try data.decodeIfPresent(String.self, forKey: .maintenance)
        self.care_level = try data.decodeIfPresent(String.self, forKey: .care_level)
        
        self.scientific_name = try data.decodeIfPresent([String].self, forKey: .scientific_name)
        self.other_name = try data.decodeIfPresent([String].self, forKey: .other_name)
        self.sunlight = try data.decodeIfPresent([String].self, forKey: .sunlight)
        self.leaf_color = try data.decodeIfPresent([String].self, forKey: .leaf_color)
        self.fruit_color = try data.decodeIfPresent([String].self, forKey: .fruit_color)
        self.soil = try data.decodeIfPresent([String].self, forKey: .soil)
        self.origin = try data.decodeIfPresent([String].self, forKey: .origin)
        self.attracts = try data.decodeIfPresent([String].self, forKey: .attracts)
        self.propagation = try data.decodeIfPresent([String].self, forKey: .propagation)
        
        let defaultImageContainer =  try data.nestedContainer(keyedBy: PlantDetailKeys.DefaultImageKeys.self, forKey: .default_image)

        self.license_name = try defaultImageContainer.decodeIfPresent(String.self, forKey: .license_name)
        self.original_url = try defaultImageContainer.decodeIfPresent(String.self, forKey: .original_url)
        self.regular_url = try defaultImageContainer.decodeIfPresent(String.self, forKey: .regular_url)
        self.medium_url = try defaultImageContainer.decodeIfPresent(String.self, forKey: .medium_url)
        self.small_url = try defaultImageContainer.decodeIfPresent(String.self, forKey: .small_url)
        self.thumbnail = try defaultImageContainer.decodeIfPresent(String.self, forKey: .thumbnail)
        
        let hardinessContainer =  try data.nestedContainer(keyedBy: PlantDetailKeys.HardinessKeys.self, forKey: .hardiness)
        
        self.min = try hardinessContainer.decodeIfPresent(String.self, forKey: .min)
        self.max = try hardinessContainer.decodeIfPresent(String.self, forKey: .max)
    }
}

// MARK: - DefaultImage
struct DefaultImage: Codable {
    var image_id, license: Int?
    var license_name: String?
    var license_url: String?
    var original_url, regular_url, medium_url, small_url: String?
    var thumbnail: String?
}

// MARK: - Hardiness
struct Hardiness: Codable {
    var min, max: String?
}
