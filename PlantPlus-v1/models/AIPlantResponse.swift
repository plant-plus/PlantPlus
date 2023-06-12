//
//  AIPlantResponse.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-11.
//

import Foundation
import UIKit

struct AIPlantResponse: Codable, Hashable {
    //var images: [Any]?
    //var meta_data: [Any]?
    var suggestions: [SuggestionsAIPlant]?
    //var modifiers: [Any]?*/
    
    var id, custom_id, countable, is_plant: Int?
    var secret, fail_cause, feedback : String?
    var uploaded_datetime, finished_datetime, is_plant_probability:Double?

    enum AIPlantKeys: String, CodingKey {
        case id
        case custom_id
        //case meta_data
        case uploaded_datetime
        case finished_datetime
        //case images
        case suggestions
        //case modifiers
        case secret
        case fail_cause
        case countable
        case feedback
        case is_plant_probability
        case is_plant
    }
    
    init() {
        //self.images = nil
        //self.meta_data = nil
        self.suggestions = nil
        //self.modifiers = nil
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: AIPlantKeys.self)
        
        self.suggestions = try dataContainer.decodeIfPresent([SuggestionsAIPlant].self, forKey: .suggestions)
    }
}


struct SuggestionsAIPlant: Codable, Hashable {
    var id : Int?
    var plant_name : String?
    var probability:Double?
    var similar_image: [SuggestionsSimilarAIPlant]?
    var image : UIImage?
    var plant_details: PlantDetailsAIPlant?
    
    init() {
        self.id = nil
        self.plant_name = nil
        self.probability = nil
        //self.confirmed = nil
        self.similar_image = nil
        self.image = nil
        self.plant_details = nil
    }

    enum SuggestionsKeys: String, CodingKey {
        case id
        case plant_name
        case probability
        //case confirmed
        case similar_image
        case image
        case plant_details
        enum SuggestionsSimilarAIPlantKeys: String, CodingKey {
            case id
            case similarity
            case url
            case url_small
        }
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SuggestionsKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        
        self.plant_name = try container.decodeIfPresent(String.self, forKey: .plant_name)
        self.probability = try container.decodeIfPresent(Double.self, forKey: .probability)
        //self.confirmed = try container.decodeIfPresent(Int.self, forKey: .confirmed)
        
        self.similar_image = try container.decodeIfPresent([SuggestionsSimilarAIPlant].self, forKey: .similar_image)
        
        self.plant_details = try container.decodeIfPresent(PlantDetailsAIPlant.self, forKey: .plant_details)
    }
}


struct SuggestionsSimilarAIPlant: Codable, Hashable {
    var id: Int?
    var url, url_small: String?
    var similarity:Double?
    
    enum SuggestionsSimilarAIPlantKeys: String, CodingKey {
        case id
        case similarity
        case url
        case url_small
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SuggestionsSimilarAIPlantKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.similarity = try container.decodeIfPresent(Double.self, forKey: .similarity)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.url_small = try container.decodeIfPresent(String.self, forKey: .url_small)
    }
}

struct PlantDetailsAIPlant: Codable, Hashable {
    var scientific_name: String?
    var wiki_image : WikiImageAIPlant?
    
    enum PlantDetailsAIPlantKeys: String, CodingKey {
        case scientific_name
        case wiki_image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlantDetailsAIPlantKeys.self)
        self.scientific_name = try container.decodeIfPresent(String.self, forKey: .scientific_name)
        self.wiki_image = try container.decodeIfPresent(WikiImageAIPlant.self, forKey: .wiki_image)
    }
}

struct WikiImageAIPlant: Codable, Hashable {
    var value: String?
    
    enum WikiImageAIPlantKeys: String, CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WikiImageAIPlantKeys.self)
        self.value = try container.decodeIfPresent(String.self, forKey: .value)
    }
    
}
