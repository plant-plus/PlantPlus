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
    var id_plant : String = "0"
    var name : String = ""
    var dateAdded : Date = Date.now
    
    init(){
    }

    init(id_plant : String,
         name : String)  {
        self.id_plant = id_plant
        self.name = name
        self.dateAdded = Date.now
    }
}
