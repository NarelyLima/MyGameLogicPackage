//
//  Models.swift
//  POC-BusinessLogic
//
//  Created by Narely Lima on 29/08/23.
//

import Foundation

public class Player {
    var id: Int
    var name: String
    var life: Int
    var individualsCards: [Cards]
    var currentIndividualsCards: [Cards]
    var killDeck: [Cards]

    public init(id: Int = Int(), name: String = String(), life: Int = 15, individualsCards: [Cards] = [Cards](), currentIndividualsCards: [Cards] = [Cards](), killDeck: [Cards] = [Cards]()) {
        self.id = id
        self.name = name
        self.life = life
        self.individualsCards = individualsCards
        self.currentIndividualsCards = currentIndividualsCards
        self.killDeck = killDeck
    }

}

public struct Cards: Equatable {
    var id = Int()
    var typeOfCards = TypesOfCards.attack
//  var description: String = ""
    var damage = Int()

    public init(id: Int = Int(), typeOfCards: TypesOfCards = TypesOfCards.attack, damage: Int = Int()) {
        self.id = id
        self.typeOfCards = typeOfCards
        self.damage = damage
    }
}

public enum TypesOfCards {
    case attack
    case defense
    case specialEffect
}


let cards: [Cards] = [Cards(id: 0, typeOfCards: .attack, damage: 15),
                      Cards(id: 1, typeOfCards: .attack, damage: 12),
                      Cards(id: 2, typeOfCards: .attack, damage: 13),
                      Cards(id: 3, typeOfCards: .attack, damage: 11),
                      Cards(id: 4, typeOfCards: .attack, damage: 6),
                      Cards(id: 5, typeOfCards: .attack, damage: 8),
                      Cards(id: 6, typeOfCards: .attack, damage: 9),
                      Cards(id: 7, typeOfCards: .attack, damage: 10),
                      Cards(id: 8, typeOfCards: .attack, damage: 5),
                      Cards(id: 9, typeOfCards: .attack, damage: 7),
                      Cards(id: 10, typeOfCards: .defense, damage: 2),
                      Cards(id: 11, typeOfCards: .defense, damage: 3),
                      Cards(id: 12, typeOfCards: .defense, damage: 1),
                      Cards(id: 13, typeOfCards: .defense, damage: 6),
                      Cards(id: 14, typeOfCards: .defense, damage: 2),
                      Cards(id: 15, typeOfCards: .defense, damage: 1),
                      Cards(id: 16, typeOfCards: .defense, damage: 7),
                      Cards(id: 17, typeOfCards: .specialEffect, damage: 0),
                      Cards(id: 18, typeOfCards: .specialEffect, damage: 1),
                      Cards(id: 19, typeOfCards: .specialEffect, damage: 1),
                      Cards(id: 20, typeOfCards: .specialEffect, damage: 1),
                      Cards(id: 21, typeOfCards: .specialEffect, damage: 1),
                      ]

//tem umas cartas que o dano é volátil e tem valor atribuido na hora do jogo
//cartas de efeitos especiais: bloquear, inverter a ordem do jogo, aumentar vida
