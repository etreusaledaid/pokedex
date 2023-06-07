//
//  PokemonManager.swift
//  Pokedex
//
//  Created by Yuss on 17/01/23.
//

import Foundation

protocol PokemonManagerDelegate{
    func didUpdatePokemon(pokemon:[PokemonModel])
    func didFailWithError(error:Error)
}

struct PokemonManager{
    let pokemonURL:String = "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0"
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(){
        perfomRequest(with: pokemonURL)
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
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    if let pokemon = self.parseJSON(pokemonData: safeData){
                        //print(pokemon)
                        self.delegate?.didUpdatePokemon(pokemon: pokemon)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonModel]?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodeData.results?.map{
                PokemonModel(name: $0.name ?? "", imageURL: $0.url ?? "")
            }
            return pokemon
        }catch{
            return nil
        }
    }
}
