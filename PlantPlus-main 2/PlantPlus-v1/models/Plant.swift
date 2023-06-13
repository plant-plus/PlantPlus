//
//  Plant.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-31.
//

import Foundation
import FirebaseFirestoreSwift

struct Plant : Codable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    var api_id : String = "n/a"
    var common_name : String = ""
// TODO: Allow user to add nickname
//    var nick_name : String = ""
    var watering : String = ""

    // TODO: Image
    var dateAdded : Date = Date.now
    
    init(){
    }

    init(api_id: String, common_name: String, watering: String) {
        self.api_id = api_id
        self.common_name = common_name
//        self.nick_name = nick_name
        self.watering = watering

        
    }
}
