import XCTest
@testable import MyGameLogic

final class MyGameLogicTests: XCTestCase {

    let gameLogic = GameLogic()

    func testFirstGame() {
        let countPlayers = 3
        gameLogic.firstGamePlay(3)
        XCTAssertEqual(gameLogic.jogadores.count, countPlayers)
    }

    func testGiveCards() {
        let countCards = cards.count
        gameLogic.jogadores.append(Player())
        gameLogic.jogadores.append(Player())
        gameLogic.jogadores.append(Player())
        gameLogic.giveCardsToPlayers(true)
        for i in 0..<3 {
            XCTAssertEqual(gameLogic.jogadores[i].individualsCards.count, countCards)
        }
    }


    func testChoosePlayer() {
        let chosenPlayer = ["Jogador 1", "Jogador 2", "Jogador 3"]
        gameLogic.firstGamePlay(3)
        gameLogic.chooseFirstPlayer()
        let player = gameLogic.currentPlayer
        XCTAssertEqual(player.name, chosenPlayer[player.id], "O player.name é \(player.name) e o escolhido foi \(chosenPlayer[player.id])")
    }

    func testOrderPlayers() {
        gameLogic.firstGamePlay(3)
        gameLogic.definitionNextPlayer(2,3)
        // quero saber se o proximo jogador é realmente o prox
        XCTAssertEqual(gameLogic.currentNextPlayer.id, 0, "o index do prox jogador é \(gameLogic.currentNextPlayer.id)")
    }

    func testActionPlayer() {
        gameLogic.firstGamePlay(3)
        gameLogic.giveCardsToPlayers(true)
        gameLogic.chooseFirstPlayer()
        gameLogic.currentPlayer.id = 2
        let player = gameLogic.currentPlayer
        // quero saber se é retornada a carta certa
        gameLogic.askActionPlayer(player, 1)
        XCTAssertEqual(gameLogic.currentCard, player.individualsCards[0])
    }

    func testHaveReaction() {
        let nextPlayer = Player()
        nextPlayer.individualsCards = [Cards(typeOfCards: .defense)]
        let currentCard = Cards(typeOfCards: .attack, damage: 5)
        gameLogic.haveAttackCard(nextPlayer, currentCard)
        let result = gameLogic.willBeAttacked

        XCTAssertFalse(result)
    }
    func testDontHaveReaction() {
        let nextPlayer = Player()
        nextPlayer.individualsCards = [Cards(typeOfCards: .attack)]
        let currentCard = Cards(typeOfCards: .attack, damage: 5)
        gameLogic.haveAttackCard(nextPlayer, currentCard)
        // como nao tem defesa ele tera q receber o ataque integral
        let result = gameLogic.willBeAttacked
        XCTAssertTrue(result)

    }

    func testTryDefense() {
        let currentCard = Cards(typeOfCards: .defense, damage: 5)
        let result = gameLogic.willBeDefense
        gameLogic.tryDefensePlayer(currentCard)
        XCTAssertTrue(result)
    }

    func testDontTryDefense() {
        let currentCard = Cards(typeOfCards: .attack, damage: 5)
        let result = gameLogic.willBeDefense
        gameLogic.tryDefensePlayer(currentCard)
        XCTAssertFalse(result)
    }

    func testTryReaction() {
        gameLogic.firstGamePlay(3)
        gameLogic.giveCardsToPlayers(true)
        gameLogic.definitionNextPlayer(1, 3)
        let player = gameLogic.currentNextPlayer
        // quero saber se é retornada a carta certa
        gameLogic.askReactionPlayer(player, 1)
        XCTAssertEqual(gameLogic.currentCardNextPlayer, player.individualsCards[0])
    }
    func testLifePlayer() {
        // função responsavel por atualizar a vida do jogador
        let player = Player(life: 25)
        let result = gameLogic.lifePlayerUpdate(4, player)

        XCTAssertEqual(result, 21)
    }

    func testDiscardCardCurrentPlayer() {
        // eu quero pegar a carta que o jogador selecionou e descartá-la e pegar a prox carta do deck

        let player = Player(individualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6), Cards(id: 7)])
        gameLogic.currentPlayer = player
        gameLogic.updateHandCards(player, 2)
        let result = gameLogic.currentPlayer.individualsCards

        XCTAssertEqual(result, player.individualsCards)

    }

    func testDiscardCardCurrentNextPlayer() {
        // eu quero pegar a carta que o jogador selecionou e descartá-la e pegar a prox carta do deck
        let nextPlayer = Player(individualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6), Cards(id: 7)])
        gameLogic.currentNextPlayer = nextPlayer
        gameLogic.updateHandCards(nextPlayer, 2)
        let result = gameLogic.currentNextPlayer.individualsCards

        XCTAssertEqual(result, nextPlayer.individualsCards)
    }
    func testPullCards() {
        let player = Player(individualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6), Cards(id: 7)], currentIndividualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6)])
        gameLogic.updateHandCards(player, 0)
        gameLogic.pullCardPlayer(player, 0)
        let result = player.currentIndividualsCards
        XCTAssertEqual(result, [Cards(id: 7), Cards(id: 4), Cards(id: 6)])
    }
    func testRedistributeCards() {
        let player = Player(individualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6), Cards(id: 7), Cards(id: 1), Cards(id: 3), Cards(id: 8)], currentIndividualsCards: [Cards(id: 0), Cards(id: 4), Cards(id: 6)])
        gameLogic.distributeCardsAgain(player, 2)
        let result = player.individualsCards
        XCTAssertEqual(result, [Cards(id: 0), Cards(id: 4), Cards(id: 7), Cards(id: 1), Cards(id: 3), Cards(id: 8)])
    }
        func testRemovePlayer() {
            let player = Player(id: 0, life: 30)
            let player2 = Player(id: 1, life: 0)
            let player3 = Player(id: 2, life: 10)
            gameLogic.jogadores.append(player)
            gameLogic.jogadores.append(player2)
            gameLogic.jogadores.append(player3)
            for jogador in gameLogic.jogadores {
                if jogador.life <= 0 {
                    gameLogic.jogadores.remove(at: jogador.id)
                }
            }
    //        gameLogic.lostGamePlayer(player3)
            print(gameLogic.jogadores[1].id)
    //        gameLogic.lostGamePlayer(player3)
//            let result = gameLogic.jogadores.count
//            XCTAssertEqual(result, 2)
        }

    func testGameplay() {
        print("Quantos jogadores vao jogar?")
        let number = gameLogic.inputUser()
        gameLogic.firstGamePlay(number)

        //RunLoop.main.run(until: .distantFuture)
    }

    
}
