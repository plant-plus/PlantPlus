//
//  IAPlantHelper.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-10.
//

import Foundation
import UIKit


class AIPlantHelper: ObservableObject {
    
    @Published var aIPlantResponse = AIPlantResponse()

    /// Encode an image file into Base64 ASCII
    func encodeFile(_ url: URL) -> String? {
        do {
            let data = try Data(contentsOf: url)
            return data.base64EncodedString()
        } catch {
            return nil
        }
    }
    
    /// Identify a plant given a list of file URLs
    func identifyPlant(from files: [URL]) async -> String? {
    //func identifyPlant(from files: [URL]) {
        let paramaters: [String: Any] = [
            "api_key": "w5RvYW48Lr3srXy9WXMh2A2VDymymNzsXCikPFEjiLFfhLK0HA",
            "images": files.compactMap(encodeFile),
            "latitude": 49.1951239,
            "longitude": 16.6077111,
            "datetime": 1582830233,
            // modifiers docs: https://github.com/flowerchecker/Plant-id-API/wiki/Modifiers
            "modifiers": ["crops_fast", "similar_images"],
            "plant_language": "en",
            // plant details docs: https://github.com/flowerchecker/Plant-id-API/wiki/Plant-details
            "plant_details": ["common_names",
                              "edible_parts",
                              "gbif_id",
                              "name_authority",
                              "propagation_methods",
                              "synonyms",
                              "taxonomy",
                              "url",
                              "wiki_description",
                              "wiki_image",
                             ],
        ]
        
        let url = URL(string: "https://api.plant.id/v2/identify")!
        //let url = URL(string: "https://plant.id/api/v2")!
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:  "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: paramaters)

        
        //let task = try! await URLSession.shared.data(for: request){
        let task = try! await URLSession.shared.data(for: request)
        
        //let jsonDecoder = JSONDecoder()
        //var aiPlantResponse = try jsonDecoder.decode(AIPlantResponse.self, from: dataJson) as AIPlantResponse
        
        let jsonDecoder = JSONDecoder()
        do{
            var aiPlantResponse = try jsonDecoder.decode(AIPlantResponse.self, from: task.0) as AIPlantResponse
            
            self.aIPlantResponse = aiPlantResponse
            
        }catch let error{
            print(#function, "Error while extracting data : \(error)")
        }
        
        
        let dataField = aIPlantResponse.suggestions!
        for disease in dataField {
            if (disease.plant_details?.wiki_image?.value != nil) {
                self.fetchImage(from: (disease.plant_details?.wiki_image?.value)!, withCompletion: {(data: Data?) in
                    
                    guard let imageData = data else{
                        print(#function, "Unable to get image data")
                        return
                    }
                    self.aIPlantResponse.suggestions! = self.aIPlantResponse.suggestions!.map{
                        var mutable = $0
                        if mutable.id == disease.id {
                            mutable.image = UIImage(data: imageData)
                        }
                        return mutable
                    }
                    //return to main thread to access UI
                    DispatchQueue.main.async {
                        self.aIPlantResponse = self.aIPlantResponse
                    }
                })
            }
        }
        
        return String(data: task.0, encoding: .utf8)
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
    
    /// Perform a plant identification request using some sample images
    func performRequest(url : URL?) {
        Task {
            let urls = [
                url!
            ]
            
            //identifyPlant(from: urls)
            if let response = await identifyPlant(from: urls) {
                //let jsonDecoder = JSONDecoder()
                //var aiPlantResponse = try jsonDecoder.decode(AIPlantResponse.self, from: response.data(using: .utf8)!) as AIPlantResponse
                //print(response)
                //print(aiPlantResponse)
            }
        }
    }
}
