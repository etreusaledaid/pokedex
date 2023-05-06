//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Yussel Coranguez on 17/01/23.
//
//  Api https://pokeapi.co/
//  JSON https://app.quicktype.io/

import UIKit
import Kingfisher

class PokedexViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButton: [UIButton]!
    
    //lazy hace que se ejecute cuando solo se necesita, no antes, no despues
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()
    var contador:Int = 0
    var mensajeScore:String = ""
    var mensajePokemon:String = ""
    
    var randomPokemon:[PokemonModel] = []{
        //didset funciona para ejecutar una funcion al inicio d la ejecucion
        didSet{
            setButtonTitles()
        }
    }
    var correctAnswer:String = ""
    var correctAnswerImage:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        imageManager.delegate = self
        
        pokemonManager.fetchPokemon()
        createButtons()
        labelMessage.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //print(sender.titleLabel?.text ?? "Pikachu")
        let userAnswer = sender.title(for:.normal)!
        
        if game.checkAnswer(userAnswer: userAnswer, correctAnswer: correctAnswer){
            labelMessage.text = "¡Si es \(userAnswer)!"
            labelScore.text = "Puntaje: \(game.score)"
            
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            
            let url = URL(string: correctAnswerImage)
            pokemonImage.kf.setImage(with: url)
            contador += 1
            mensajeScore = "Puntaje: \(game.score)"
            mensajePokemon = "¡Si es \(userAnswer)!"
            
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){ [self] timer in
                if contador == 5{
                    contador = 0
                    self.performSegue(withIdentifier: "goToResults", sender: self)
                }
                self.pokemonManager.fetchPokemon()
                self.labelMessage.text = ""
                sender.layer.borderColor = nil
                sender.layer.borderWidth = 0
            }
        }else{
            labelMessage.text = "Nooo !Es \(correctAnswer)!"
            labelScore.text = "Puntaje: \(game.score)"
            sender.layer.borderColor = UIColor.systemRed.cgColor
            sender.layer.borderWidth = 2
            game.setScore(score: game.score)
            
            let url = URL(string: correctAnswerImage)
            pokemonImage.kf.setImage(with: url)
            contador += 1
            mensajeScore = "Puntaje: \(game.score)"
            mensajePokemon = "Nooo !Es \(correctAnswer)!"
            
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){ [self]timer in
                if contador == 5{
                    contador = 0
                    self.performSegue(withIdentifier: "goToResults", sender: self)
                }
                self.pokemonManager.fetchPokemon()
                self.labelMessage.text = ""
                sender.layer.borderColor = nil
                sender.layer.borderWidth = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults"{
            let destination = segue.destination as! ResultsViewController
            destination.pokemonName = correctAnswer
            destination.pokemonImageURL = correctAnswerImage
            destination.finalScore = game.score
            destination.mensajeScore = mensajeScore
            destination.mensajePokemon = mensajePokemon
        }
    }
    
    func createButtons(){
        for button in answerButton{
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 10.0
        }
    }
    
    func setButtonTitles(){
        for(index,button) in answerButton.enumerated(){
            DispatchQueue.main.async { [self] in
                button.setTitle(randomPokemon[safe:index]?.name.capitalized, for: .normal)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PokedexViewController: PokemonManagerDelegate{
    func didUpdatePokemon(pokemon: [PokemonModel]) {
        //print(pokemon.choose(n: 4))
        randomPokemon = pokemon.choose(n: 4)
        
        //Metodo para generar numero aleatorio de 0 a 3
        let index = Int.random(in: 0...3)
        let imageData = randomPokemon[index].imageURL
        correctAnswer = randomPokemon[index].name
        
        imageManager.fetchImage(url:imageData)
    }
    
    func didFailWithError(error: Error) {
        print("ERROR EN ACTUALIZAR \(error)")
    }
}

extension Collection where Indices.Iterator.Element == Index{
    public subscript(safe index:Index) -> Iterator.Element?{
        return (startIndex <= index && index < endIndex) ? self[index]:nil
    }
}

extension Collection{
    func choose(n:Int) -> Array<Element>{
        //shuffled es para revolver el orden que nos da la api
        Array(shuffled().prefix(n))
    }
}

extension PokedexViewController: ImageManagerDelegate{
    func didUpdatePokemonImage(image: ImageModel) {
        //print(image.imageURL)
        correctAnswerImage = image.imageURL
        
        DispatchQueue.main.async { [self] in
            let url = URL(string: image.imageURL)
            
            pokemonImage.kf.setImage(with: url)
            
            let effect = ColorControlsProcessor(brightness: -1.0, contrast: 1.0, saturation: 1.0, inputEV: 0.0)
            pokemonImage.kf.setImage(
                with: url,
                options: [.processor(effect)]
            )
        }
    }
    
    func didFailWithErrorImage(error: Error) {
        print("ERROR EN IMAGEN \(error)")
    }
    
    
}
