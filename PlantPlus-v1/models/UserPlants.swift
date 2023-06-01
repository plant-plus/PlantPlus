//
//  UserPlants.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-31.
//

import Foundation
import FirebaseFirestoreSwift

struct UserPlants : Codable, Hashable{
    var name : String = ""
    var email : String = ""
    var contactNumber : String = ""
    
    init(){
    }

    init(name : String,
         email : String,
         contactNumber : String)  {
        self.name = name
        self.email = email
        self.contactNumber = contactNumber
    }
}
