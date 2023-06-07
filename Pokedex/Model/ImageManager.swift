//
//  ImageManager.swift
//  Pokedex
//
//  Created by Yuss on 17/01/23.
//

import Foundation

protocol ImageManagerDelegate{
    func didUpdatePokemonImage(image:ImageModel)
    func didFailWithErrorImage(error:Error)
}

struct ImageManager{
    var delegate: ImageManagerDelegate?
    
    func fetchImage(url:String){
        perfomRequest(with: url)
    }
    
    private func perfomRequest(with urlString:String){
        //1. create/get url
        if let url = URL(string: urlString){
            //2. create the urlsession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    //print(error ?? "error")
                    self.delegate?.didFailWithErrorImage(error: error!)
                }
                if let safeData = data{
                    if let image = self.parseJSON(imageData: safeData){
                        //print(pokemon)
                        self.delegate?.didUpdatePokemonImage(image: image)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    private func parseJSON(imageData: Data) -> ImageModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            let normal = decodeData.sprites.other?.officialArtwork.frontDefault
            let shiny = decodeData.sprites.other?.officialArtwork.frontShiny
            
            let index = Int.random(in: 0...1)
            if index == 0{
                return ImageModel(imageURL: normal!)
            }else{
                return ImageModel(imageURL: shiny!)
            }
        }catch{
            return nil
        }
    }
}

