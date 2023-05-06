//
//  GameModel.swift
//  Pokedex
//
//  Created by Yussel Coranguez on 17/01/23.
//

import Foundation

struct GameModel{
    var score = 0
    
    //Revisar respuesta
    mutating func checkAnswer(userAnswer:String, correctAnswer:String) -> Bool {
        if userAnswer.lowercased() == correctAnswer.lowercased(){
            score += 1
            return true
        }else{
            if(score > 0){
                score -= 1
            }
            return false
        }
    }
    
    //Obtener el score
    func getScore() -> Int {
        return score
    }
    
    //Reinicio score, mutating funciona para poder modificar los parametros porque en una estructura no se puede
    mutating func setScore(score:Int){
        self.score = score
    }
}
