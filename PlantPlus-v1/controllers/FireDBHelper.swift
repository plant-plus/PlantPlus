//
//  FireDBHelper.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-31.
//

import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject{
    
    private let store : Firestore
    private static var shared : FireDBHelper?
    
    @Published var plantList = [Plant]()
    
    @Published var user = UserPlants()
    
    private let COLLECTION_USERS : String = "users_plant"
    private let COLLECTION_PLANTS : String = "plants"
    
    private let COLLECTION_PLANTS_USERS : String = "plants_array"
    
    private let FIELD_USER_NAME : String = "name"
    private let FIELD_USER_EMAIL : String = "email"
    private let FIELD_USER_CONTACT_NUMBER : String = "contactNumber"
    
    var loggedInUserEmail = ""
    
    init(store: Firestore) {
        self.store = store
    }
    
    static func getInstance() -> FireDBHelper?{
        if(shared == nil){
            shared = FireDBHelper(store : Firestore.firestore())
        }
        
        return shared
    }
    
    func insertPlant(newPlant : Plant, userID : String) {
        print(#function, "Trying to insert plant \(newPlant.name) to firestore")
        
        do{
            try self.store
                .collection(COLLECTION_PLANTS)
                .document(userID)
                .collection(COLLECTION_PLANTS_USERS)
                .addDocument(from: newPlant)
        }catch let error as NSError{
            print(#function, "Unable to add document to firestore : \(error)")
        }
    }
    
    
    func getAllPlants(plantID : String) {
        self.store
            .collection(COLLECTION_PLANTS)
            .document(plantID)
            .collection(COLLECTION_PLANTS_USERS)
            .addSnapshotListener({ (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else{
                    print(#function, "Unable to retrieve data from Firestore : \(error)")
                    return
                }
                
                snapshot.documentChanges.forEach{ (docChange) in
                    
                    do{
                        var plant : Plant = try docChange.document.data(as: Plant.self)
                        
                        let docID = docChange.document.documentID
                        plant.id = docID
                        
                        let matchedIndex = self.plantList.firstIndex(where: { ($0.id?.elementsEqual(docID))! })
                        
                        if docChange.type == .added{
                            self.plantList.append(plant)
                            print(#function, "Document added : \(plant)")
                        }
                        
                        if docChange.type == .removed{
                            if (matchedIndex != nil){
                                self.plantList.remove(at: matchedIndex!)
                            }
                        }
                        
                        if docChange.type == .modified{
                            if (matchedIndex != nil){
                                self.plantList[matchedIndex!] = plant
                            }
                        }
                    }catch let err as Error{
                        print(#function, "Unable to convert the document into object : \(err)")
                    }
                }
                
            })
        
    }
    
    func insertUser(newUser : UserPlants){
        print(#function, "Trying to insert user \(newUser.email) to firestore")
        
        do{
            try self.store
                .collection(COLLECTION_USERS)
                .document(newUser.email.lowercased())
                .setData(from: newUser)
            
            print(#function, "User \(newUser.email) inserted to firestore")
        }catch let error as NSError{
            print(#function, "Unable to add document to firestore : \(error)")
        }
    }
    
    func updateUser(userToUpdate : UserPlants, userID : String){
        self.store
            .collection(COLLECTION_USERS)
            .document(userID)
            .updateData([FIELD_USER_NAME : userToUpdate.name,
                        FIELD_USER_EMAIL : userToUpdate.email,
               FIELD_USER_CONTACT_NUMBER : userToUpdate.contactNumber
                        ]){error in
                
                if let error = error {
                    print(#function, "Unable to update document : \(error)")
                }else{
                    print(#function, "Successfully updated \(userToUpdate.email) user in the firestore")
                }
            }
    }
    
    func getUser() {
        loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (loggedInUserEmail.isEmpty){
            print(#function, "Logged in user not identified")
            return
        }
        
        self.store
            .collection(COLLECTION_USERS)
            .document(loggedInUserEmail)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                do {
                    self.user = try document.data(as: UserPlants.self)
                    print("Current data: \(document.data())")
                } catch let signOutError as NSError {
                    print(#function, "Unable to sign out user: \(signOutError)")
                }
            }
    }
}
