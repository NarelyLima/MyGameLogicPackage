import Foundation


/*
 lib -> conjunto de código reusável
 framework -> lib que padroniza/abstrair o jeito de fazer algo

 app | internet | api    ->   web service | database
                  public      private

 Mythos | api      ->     MyGameLogic
        | public          internal
 */

public class GameLogic {

    var jogadores: [Player] = []
    var numberOfPlayers: Int = 0
    var distributeCards: Bool = false
    var startGame: Bool = false
    var willBeAttacked: Bool = true
    var willBeDefense: Bool = true
    var numberOfCard: Int = 0
    var currentPlayer = Player()
    var currentCard = Cards()
    var currentNextPlayer = Player()
    var currentIndex: Int = 0
    var currentIndexNextPlayer: Int = 0
    var currentCardNextPlayer = Cards()
    var direcionamento: Int = 1
    let cardsShuffle = cards.shuffled()
    var randomCards: [Cards] = []
    var danoTotal: Int = 0

    public init() { }

    // da 3 cartas aleatorias para cada jogador

    public func firstGamePlay(_ numberOfPlayers: Int) {
        // colocar a função numberOfPlayers = inputUser()
        print("Jogarão \(numberOfPlayers) pessoas")
        if numberOfPlayers == 3 || numberOfPlayers == 4 {
            for i in 0..<numberOfPlayers {
                jogadores.append(Player(id: i, name: "Jogador \(i+1)"))
            }
            distributeCards = true
            //            // da cartas
            giveCardsToPlayers(distributeCards)
            giveThreeCardsToPlayers(distributeCards)
        }
//            // seleciona o primeiro jogador
//            chooseFirstPlayer()
////            // define o prox jogador
//            definitionNextPlayer(currentIndex, jogadores.count)
//
////            // anuncia q o primeiro jogador deve começar
//            sendMessagePlayer(currentPlayer)
////            // pergunta qual a carta q o jogador vai usar para atacar
//            print("""
//                Name:  \(currentPlayer.name)
//                Life:  \(currentPlayer.life)
//                Cards: [1] \(currentPlayer.individualsCards[0].typeOfCards) Dano: \(currentPlayer.individualsCards[0].damage)
//                       [2] \(currentPlayer.individualsCards[1].typeOfCards) Dano: \(currentPlayer.individualsCards[1].damage)
//                       [3] \(currentPlayer.individualsCards[2].typeOfCards) Dano: \(currentPlayer.individualsCards[2].damage)
//            """
//            )
//            askActionPlayer(currentPlayer, numberOfCard)
////            // pergunta qual a carta q o jogador vai usar para se defender
////            // e faz a tentativa de ataque
//            print("""
//                        JOGADOR ATACADO
//                Name:  \(currentNextPlayer.name)
//                Life:  \(currentNextPlayer.life)
//                Cards: [1] \(currentNextPlayer.individualsCards[0].typeOfCards) Dano: \(currentNextPlayer.individualsCards[0].damage)
//                       [2] \(currentNextPlayer.individualsCards[1].typeOfCards) Dano: \(currentNextPlayer.individualsCards[1].damage)
//                       [3] \(currentNextPlayer.individualsCards[2].typeOfCards) Dano: \(currentNextPlayer.individualsCards[2].damage)
//            """
//            )
//            haveAttackCard(currentNextPlayer, currentCard)
//            nextPlayer()
//
//        } else {
//            print("Infelizmente só 3 ou 4 jogadores poderão jogar")
//            distributeCards = false
//        }
    }
    // da cartas

    func giveThreeCardsToPlayers(_ giveCards: Bool) {
        if giveCards {
            for jogador in jogadores {
                for i in 0..<3 {
                    jogador.currentIndividualsCards.append(jogador.individualsCards[i])
                    print(jogador.currentIndividualsCards)
                }
            }
        } else {
            print("Deu erro")
        }
    }

    func giveCardsToPlayers(_ start: Bool) {
        if start {
            for jogador in 0..<jogadores.count {
                jogadores[jogador].individualsCards = dealCards()
                randomCards = []
            }
        } else {
            print("Deu erro")
        }
    }

    func defaultGamePlay(_ index: Int, _ life: Int) {

        currentPlayer = jogadores[index]
        currentIndex = currentPlayer.id
//        // define o prox jogador
        definitionNextPlayer(index, jogadores.count)
        // anuncia q o primeiro jogador deve começar
        sendMessagePlayer(currentPlayer)
        // pergunta qual a carta q o jogador vai usar para atacar
        print("""
            Name:  \(currentPlayer.name)
            Life:  \(life)
            Cards: [1] \(currentPlayer.individualsCards[0].typeOfCards) Dano: \(currentPlayer.individualsCards[0].damage)
                   [2] \(currentPlayer.individualsCards[1].typeOfCards) Dano: \(currentPlayer.individualsCards[1].damage)
                   [3] \(currentPlayer.individualsCards[2].typeOfCards) Dano: \(currentPlayer.individualsCards[2].damage)
        """
        )
        askActionPlayer(currentPlayer, numberOfCard)
        // pergunta qual a carta q o jogador vai usar para se defender
        // e faz a tentativa de ataque
        print("""
            JOGADOR ATACADO
            Name:  \(currentNextPlayer.name)
            Life:  \(currentNextPlayer.life)
            Cards: [1] \(currentNextPlayer.individualsCards[0].typeOfCards) Dano: \(currentNextPlayer.individualsCards[0].damage)
                   [2] \(currentNextPlayer.individualsCards[1].typeOfCards) Dano: \(currentNextPlayer.individualsCards[1].damage)
                   [3] \(currentNextPlayer.individualsCards[2].typeOfCards) Dano: \(currentNextPlayer.individualsCards[2].damage)
        """
        )
        haveAttackCard(currentNextPlayer, currentCard)
        nextPlayer()
    }

    func dealCards() -> [Cards] {

        for _ in 0..<cardsShuffle.count {
            randomCards.append(cardsShuffle.randomElement()!)
        }
        return randomCards
    }

//    func dealThreeCards() -> [Cards] {
////        for jogador in jogador 
//    }

    // Escolhe o jogador atual e o próximo jogador em relaçao a ele

    func chooseFirstPlayer() {
        // seleciona o primeiro jogador
        currentPlayer = jogadores.randomElement()!
        currentIndex = currentPlayer.id

    }
    // define o prox jogador

    func definitionNextPlayer(_ index: Int, _ numberOfPlayers: Int) {

        currentIndexNextPlayer = (index + direcionamento) % numberOfPlayers
        currentNextPlayer = jogadores[currentIndexNextPlayer]
    }

    // avisa ao jogador que é a vez dele jogar

    func sendMessagePlayer(_ player: Player) {
        print("\(player.name), você é o próximo a jogar")
    }

    // pergunta qual carta irá jogar

    func askActionPlayer(_ player: Player, _ numberCard: Int) {

        print("Qual carta você irá jogar? [1, 2 ou 3]")
        numberOfCard = inputUser()
        let validOptions2 = [1, 2, 3]

        if !validOptions2.contains(numberOfCard) {
            while !validOptions2.contains(numberOfCard) {
                print("Qual carta você irá jogar? [1, 2 ou 3]")
                numberOfCard = inputUser()
            }
        } else {
            if currentPlayer.individualsCards.contains(where: { tipo in
                tipo.typeOfCards == .attack
            }) {
                currentCard = currentPlayer.individualsCards[numberOfCard-1]
                updateHandCards(currentPlayer, numberOfCard-1)
            } else {
                updateHandCards(currentPlayer, numberOfCard-1)
                nextPlayer()
            }
        }
    }

    // 1º Cenário: ATAQUE X DEFESA

    // tentativa de ataque no próximo jogador

    func haveAttackCard(_ nextPlayer: Player, _ currentCard: Cards) {
        if nextPlayer.individualsCards.contains(where: { tipo in
            tipo.typeOfCards == .defense
        }) {
            askReactionPlayer(nextPlayer, numberOfCard)
            willBeAttacked = false
        }
        else {
            willBeAttacked = true
            danoTotal = currentCard.damage
            danoTotal = danoTotal <= 0 ? 0 : danoTotal

            currentNextPlayer.life = lifePlayerUpdate(danoTotal, currentNextPlayer)

            print("Você nao tem carta de defesa, logo recebeu dano")
            
            print("A vida do jogador atacado é: ", currentNextPlayer.life)
        }
    }

    func tryDefensePlayer(_ cardNextPlayer: Cards) {

        // verifica se o prox jogador tem carta de defesa
        if cardNextPlayer.typeOfCards == .attack {
            willBeDefense = false
            print("Você nao pode se defender usando um ataque, escolha uma carta q seja de defesa")
            askReactionPlayer(currentNextPlayer, numberOfCard)

        } else if cardNextPlayer.typeOfCards == .defense ||  currentCardNextPlayer.typeOfCards == .specialEffect {
            willBeDefense = true
            danoTotal = currentCard.damage - currentCardNextPlayer.damage
            danoTotal = danoTotal <= 0 ? 0 : danoTotal
            currentNextPlayer.life = lifePlayerUpdate(danoTotal, currentNextPlayer)

            print("A vida do jogador atacado é: ", currentNextPlayer.life)
        }
    }

    // pergunta com qual carta a pessoa vai se defender

    func askReactionPlayer(_ player: Player, _ numberCard: Int) {

        print("Com qual carta você irá reagir? [1, 2 ou 3]")
        numberOfCard = inputUser()
        let validOptions2 = [1, 2, 3]

        if !validOptions2.contains(numberOfCard) {
            while !validOptions2.contains(numberOfCard) {
                print("Qual carta você irá jogar? [1, 2 ou 3]")
                numberOfCard = inputUser()
            }
        } else {
            currentCardNextPlayer = currentNextPlayer.individualsCards[numberOfCard-1]
            tryDefensePlayer(currentCardNextPlayer)
            updateHandCardsNextPlayer(currentNextPlayer, numberOfCard-1)
        }
    }

    // define a ordem dos jogadores

    func inverterDirecionamento() {
        direcionamento = direcionamento == 1 ? -1 : 1
    }

    func nextPlayer() {
        currentIndex = (currentIndex + direcionamento) % jogadores.count
        currentPlayer.life = currentNextPlayer.life
        defaultGamePlay(currentIndex,currentPlayer.life)
    }

    func lifePlayerUpdate(_ danoTotal: Int, _ nextPlayer: Player) -> Int {

        let lifeBeforeAttack = nextPlayer.life
        let lifeAfterAttack = lifeBeforeAttack - danoTotal
        currentNextPlayer.life = lifeAfterAttack
        return lifeAfterAttack

    }

    func updateHandCards(_ player: Player, _ numberCard: Int) {

        var handDeckBeforeMoviment = player.individualsCards
        let killDeck = handDeckBeforeMoviment.remove(at: numberCard)
        player.individualsCards = handDeckBeforeMoviment
        player.killDeck.append(killDeck)

    }

    func updateHandCardsNextPlayer(_ nextPlayer: Player, _ numberCard: Int) {

        var handDeckBeforeMoviment = nextPlayer.individualsCards
        let killDeck = handDeckBeforeMoviment.remove(at: numberCard)
        nextPlayer.individualsCards = handDeckBeforeMoviment
        nextPlayer.killDeck.append(killDeck)

    }

    func inputUser() -> Int {
        let numberInputs = readLine()!
        let numberOfInputs = Int(numberInputs)!
        return numberOfInputs
    }

}
