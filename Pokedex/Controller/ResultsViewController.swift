//
//  ResultsViewController.swift
//  Pokedex
//
//  Created by Yuss on 23/01/23.
//

import UIKit
import Kingfisher

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var resultadoLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var pokemonName:String = ""
    var pokemonImageURL:String = ""
    var finalScore:Int = 0
    var mensajeScore:String = ""
    var mensajePokemon:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if finalScore < 3{
            resultadoLabel.text = "!OOPS¡ Perdiste"
        }else{
            resultadoLabel.text = "!WIII¡ Ganaste"
        }
        
        scoreLabel.text = mensajeScore
        pokemonLabel.text = mensajePokemon
        pokemonImage.kf.setImage(with: URL(string: pokemonImageURL))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
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
