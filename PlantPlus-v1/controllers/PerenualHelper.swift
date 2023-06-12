//
//  PerenualHelper.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import Foundation
import UIKit

class PerenualHelper: ObservableObject {
    @Published var perenualResponse = PerenualResponse()
    
    @Published var plantList = [PerenualResponse]()
    
    @Published var diseasesData = DataDiseases()
    
    @Published var plantDetailResponse = PlantDetail()
    
    private let basePlantListURL = "https://perenual.com/api/species-list"
    private let basePlantDetailURL = "https://perenual.com/api/species/details/"
    
    private let baseDiseaseListURL = "https://perenual.com/api/pest-disease-list"
    
    private let key = "sk-WHpd642078d49d4ef348"
    
    func fetchPlantList() {
        let apiURL = "\(basePlantListURL)?page=1&key=\(key)"
        
        guard let api = URL(string: apiURL) else{
            print(#function, "Unable to convert string to URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: api){ (data : Data?, response : URLResponse?, error : Error?) in
            
            if let error = error{
                print(#function, "Error while connecting to network \(error)")
            }else{
                
                if let httpResponse = response as? HTTPURLResponse{
                    
                    if (httpResponse.statusCode == 200){
                        
                        //execute background asynchronous task to decode the response
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data{
                                        
                                        print("ESTE ES PRUEBA 0")
                                        print(jsonData)
                                        let jsonDecoder = JSONDecoder()
                                        var perenualResponse = try jsonDecoder.decode(PerenualResponse.self, from: jsonData) as PerenualResponse
                                        

                                        let dataField = perenualResponse.data!
                                        for disease in dataField {
                                            if (disease.default_image?.small_url != nil) {
                                                self.fetchImage(from: (disease.default_image?.small_url)!, withCompletion: {(data: Data?) in
                                                    
                                                    guard let imageData = data else{
                                                        print(#function, "Unable to get image data")
                                                        return
                                                    }
                                                    perenualResponse.data! = perenualResponse.data!.map{
                                                        var mutable = $0
                                                        if mutable.id == disease.id {
                                                            mutable.image = UIImage(data: imageData)
                                                        }
                                                        return mutable
                                                    }
                                                    //                                                    data.filter(where: { $0.id = disease.id })?.image = UIImage(data: imageData)
                                                    
                                                    //                                                    print(#function, "PerenualResponse Info Received : \(perenualResponse)")
                                                    
                                                    //return to main thread to access UI
                                                    DispatchQueue.main.async {
                                                        
                                                        
                                                        //self.perenualResponse = perenualResponse
                                                        //completion(perenualResponse)
                                                        
                                                        self.perenualResponse = perenualResponse
                                                    }
                                                })
                                            }
                                        }
                                    }else{
                                        print(#function, "Unable to get the JSON data")
                                    }
                                }else{
                                    print(#function, "Response received without data")
                                }
                            }catch let error{
                                print(#function, "Error while extracting data : \(error)")
                            }
                        }
                    }else{
                        print(#function, "Unsuccessful response. Response Code : \(httpResponse.statusCode)")
                    }
                }else{
                    print(#function, "Unable to get HTTP Response")
                }
            }
        }
        
        //execute the task
        task.resume()
    }
    
    func fetchImage(from url : String, withCompletion completion: @escaping (Data?) -> Void){

        if (url != nil){
            let imgURL : URL = URL(string: url)!

            let imageTask = URLSession.shared.dataTask(with: imgURL, completionHandler: {(data : Data?, response: URLResponse?, error : Error?) -> Void in

                if error != nil{
                    print(#function, "Unable to get the image")
                }else{
                    if (data != nil){
                        DispatchQueue.main.async {
                            completion(data)
                        }
                    }
                }

            })

            imageTask.resume()
        }

    }
    
    func fetchPlant(id: String, withCompletion completion: @escaping (PlantDetail?) -> Void) {
            let apiURL = "\(basePlantDetailURL)\(id)?key=\(key)"
            print(#function, "\(apiURL)")
            guard let api = URL(string: apiURL) else{
                print(#function, "Unable to convert string to URL")
                return
            }
            let task = URLSession.shared.dataTask(with: api){ (data : Data?, response : URLResponse?, error : Error?) in
                
                if let error = error{
                    print(#function, "Error while connecting to network \(error)")
                }else{
                    if let httpResponse = response as? HTTPURLResponse{
                        
                        if (httpResponse.statusCode == 200){
                            
                            //execute background asynchronous task to decode the response
                            DispatchQueue.global().async {
                                do{
                                    if (data != nil){
                                        if let jsonData = data{
                                            
                                            let jsonDecoder = JSONDecoder()
                                            var plantDetailResponse = try jsonDecoder.decode(PlantDetail.self, from: jsonData)
                                            if (plantDetailResponse.small_url != nil){
                                                self.fetchImage(from: (plantDetailResponse.small_url)!, withCompletion: {(data: Data?) in
                                                    guard let imageData = data else{
                                                        print(#function, "Unable to get image data")
                                                        return
                                                    }
                                                    
                                                    plantDetailResponse.image = UIImage(data: imageData)
                                                    
                                                    print(#function, "PerenualResponse Info Received : \(plantDetailResponse)")
                                                    
                                                    //return to main thread to access UI
                                                    DispatchQueue.main.async {
                                                        self.plantDetailResponse = plantDetailResponse
                                                        print(#function, "\(plantDetailResponse)")
                                                        completion(plantDetailResponse)
                                                    }
                                                })
                                            }
                                        }else{
                                            print(#function, "Unable to get the JSON data")
                                        }
                                    }else{
                                        print(#function, "Response received without data")
                                    }
                                }catch let error{
                                    print(#function, "Error while extracting data : \(error)")
                                }
                            }
                        }else{
                            print(#function, "Unsuccessful response. Response Code : \(httpResponse.statusCode)")
                        }
                    }else{
                        print(#function, "Unable to get HTTP Response")
                    }
                }
            }
            
            //execute the task
            task.resume()
        }
    
    func fetchDiseaseList() -> Void {
        let apiURL = "\(baseDiseaseListURL)?key=\(key)"
        
        guard let api = URL(string: apiURL) else{
            print(#function, "Unable to convert string to URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: api){ (data : Data?, response : URLResponse?, error : Error?) in
            
            if let error = error{
                print(#function, "Error while connecting to network \(error)")
            }else{
                
                if let httpResponse = response as? HTTPURLResponse{
                    
                    if (httpResponse.statusCode == 200){
                        
                        //execute background asynchronous task to decode the response
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data{
                                        
                                        let jsonDecoder = JSONDecoder()
                                        var perenualResponse = try jsonDecoder.decode(DataDiseases.self, from: jsonData) as DataDiseases
                                        let dataField = perenualResponse.data!
                                        for disease in dataField {
                                            if (disease.images?.first?.small_url != nil) {
                                                self.fetchImage(from: (disease.images?.first?.small_url)!, withCompletion: {(data: Data?) in
                                                    
                                                    guard let imageData = data else{
                                                        print(#function, "Unable to get image data")
                                                        return
                                                    }
                                                    perenualResponse.data! = perenualResponse.data!.map{
                                                        var mutable = $0
                                                        if mutable.id == disease.id {
                                                            mutable.image = UIImage(data: imageData)
                                                        }
                                                        return mutable
                                                    }
//                                                    data.filter(where: { $0.id = disease.id })?.image = UIImage(data: imageData)
                                                    
//                                                    print(#function, "PerenualResponse Info Received : \(perenualResponse)")
                                                    
                                                    //return to main thread to access UI
                                                    DispatchQueue.main.async {
                                                        
                                                        
                                                        //self.perenualResponse = perenualResponse
                                                        //completion(perenualResponse)
                                                        
                                                        self.diseasesData = perenualResponse
                                                    }
                                                })
                                            }
                                        }
                                    }else{
                                        print(#function, "Unable to get the JSON data")
                                    }
                                }else{
                                    print(#function, "Response received without data")
                                }
                            }catch let error{
                                print(#function, "Error while extracting data : \(error)")
                            }
                        }
                    }else{
                        print(#function, "Unsuccessful response. Response Code : \(httpResponse.statusCode)")
                    }
                }else{
                    print(#function, "Unable to get HTTP Response")
                }
            }
        }
        
        //execute the task
        task.resume()
    }
}
