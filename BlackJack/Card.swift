//
//  Card.swift
//  BlackJack
//
//  Created by HanYuan on 2022/12/13.
//

import Foundation

let suits = ["♣️", "♦️", "♥️", "♠️"]
let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

var cards = [Card]()

struct Card {
    var suit = ""
    var rank = ""
}

func addCard() {
    for rank in ranks {
        for suit in suits {
            var card = Card()
            card.rank = rank
            card.suit = suit
            cards.append(card)
        }
    }
}
