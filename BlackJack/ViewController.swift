//
//  ViewController.swift
//  BlackJack
//
//  Created by HanYuan on 2022/12/9.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bankerScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    
    @IBOutlet var bankerViews: [UIView]!
    @IBOutlet var playerViews: [UIView]!
    
    @IBOutlet var bankerRankLabels: [UILabel]!
    @IBOutlet var playerRankLabels: [UILabel]!
    
    @IBOutlet var bankerSuitLabels: [UILabel]!
    @IBOutlet var bankerSuitBLabels: [UILabel]!
    @IBOutlet var playerSuitLabels: [UILabel]!
    @IBOutlet var playerSuitBLabels: [UILabel]!
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var hiddenCard: UIButton!
    
    @IBOutlet weak var betNum: UISegmentedControl!
    
    var index = 1
    var bankerCards = [Card]()
    var playerCards = [Card]()
    
    var bankerScore = 0
    var playerScore = 0
    var bet = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func calculateRankNumber(card: Card) ->Int {
        var cardRankNumber = 0
        switch card.rank{
        case "A":
            cardRankNumber = 1
        case "J","Q","K":
            cardRankNumber = 10
        default:
            cardRankNumber = Int(card.rank)!
        }
        return cardRankNumber
    }
    
    func initGame() {
        cards = [Card]()
        addCard()
        bankerCards = [Card]()
        playerCards = [Card]()
        hiddenCard.isHidden = false
        
        
        for i in 2...4 {
            bankerViews[i].isHidden = true
            playerViews[i].isHidden = true
        }
        
        bankerScore = 0
        playerScore = 0
        index = 1
        
        for i in 0...1 {
            cards.shuffle()
            bankerCards.append(cards.first!)
            cards.removeFirst()
            playerCards.append(cards.first!)
            cards.removeFirst()
            
            bankerRankLabels[i].text = bankerCards[i].rank
            bankerSuitLabels[i].text = bankerCards[i].suit
            bankerSuitBLabels[i].text = bankerCards[i].suit
            playerRankLabels[i].text = playerCards[i].rank
            playerSuitLabels[i].text = playerCards[i].suit
            playerSuitBLabels[i].text = playerCards[i].suit
            bankerScore += calculateRankNumber(card: bankerCards[i])
            playerScore += calculateRankNumber(card: playerCards[i])
        }
        
        bankerScoreLabel.text = "?"
        playerScoreLabel.text = String(playerScore)
    }
    
    func betPlus() {
        if betNum.selectedSegmentIndex == 0 {
            bet += 50
            betLabel.text = String(bet)
        } else {
            bet += 100
            betLabel.text = String(bet)
        }
    }
    
    func betMinus() {
        if betNum.selectedSegmentIndex == 0 {
            bet -= 50
            betLabel.text = String(bet)
        } else {
            bet -= 100
            betLabel.text = String(bet)
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        hitButton.isEnabled = true
        standButton.isEnabled = true
        initGame()
        bet = 1000
        betLabel.text = String(bet)
    }
    
    @IBAction func hitButton(_ sender: UIButton) {
        
        index += 1
        playerCards.append(cards.first!)
        cards.removeFirst()
        playerRankLabels[index].text = playerCards[index].rank
        playerSuitLabels[index].text = playerCards[index].suit
        playerSuitBLabels[index].text = playerCards[index].suit
        playerViews[index].isHidden = false
        playerScore += calculateRankNumber(card: playerCards[index])
        playerScoreLabel.text = String(playerScore)
        
        if playerScore > 21 {
            let controller = UIAlertController(title: "You Lose\nPlayer:Bust", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            betMinus()
        } else if playerScore == 21 {
            let controller = UIAlertController(title: "BlackJack,You Win", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } else if playerScore <= 21 && index == 4 {
            let controller = UIAlertController(title: "過五關, You win", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            betPlus()
        }
    }
    @IBAction func standButton(_ sender: UIButton) {
        hiddenCard.isHidden = true
        bankerScoreLabel.text = String(bankerScore)
        if bankerScore < 17 {
            for i in 2...4 {
                if bankerScore < 17 {
                    bankerCards.append(cards.first!)
                    cards.removeFirst()
                    bankerRankLabels[i].text = bankerCards[i].rank
                    bankerSuitLabels[i].text = bankerCards[i].suit
                    bankerSuitBLabels[i].text = bankerCards[i].suit
                    bankerViews[i].isHidden = false
                    bankerScore += calculateRankNumber(card: bankerCards[i])
                    bankerScoreLabel.text = String(bankerScore)
                }
            }
        }
        if bankerScore > playerScore && bankerScore <= 21 {
            let controller = UIAlertController(title: "You Lose", message: "Banker:\(bankerScore)\nPlayer:\(playerScore)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true)
            betMinus()
        } else if bankerScore < playerScore {
            let controller = UIAlertController(title: "You Win", message: "Banker:\(bankerScore)\nPlayer:\(playerScore)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true)
            betPlus()
        } else if bankerScore == playerScore {
            let controller = UIAlertController(title: "和局", message: "Banker:\(bankerScore)\nPlayer:\(playerScore)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true)
        }  else {
            let controller = UIAlertController(title: "You Win", message: "Banker:Bust", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { action in
                self.initGame()
            }
            controller.addAction(action)
            present(controller, animated: true)
            betPlus()
        }
    }
}

