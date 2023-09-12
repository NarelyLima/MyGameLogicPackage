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

    // State
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
    var handCards: [Cards] = []
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
            // da cartas
            giveCardsToPlayers(distributeCards)

            startGame = true

            giveThreeCardsToPlayers(startGame)
            // seleciona o primeiro jogador
            chooseFirstPlayer()
            // define o prox jogador
            definitionNextPlayer(currentIndex, jogadores.count)

            // anuncia q o primeiro jogador deve começar
            sendMessagePlayer(currentPlayer)
            //            // pergunta qual a carta q o jogador vai usar para atacar
            print("""
                Name:  \(currentPlayer.name)
                Life:  \(currentPlayer.life)
                Cards: [1] \(currentPlayer.currentIndividualsCards[0].typeOfCards) Dano: \(currentPlayer.individualsCards[0].damage)
                       [2] \(currentPlayer.currentIndividualsCards[1].typeOfCards) Dano: \(currentPlayer.individualsCards[1].damage)
                       [3] \(currentPlayer.currentIndividualsCards[2].typeOfCards) Dano: \(currentPlayer.individualsCards[2].damage)
            """
            )
            askActionPlayer(currentPlayer, numberOfCard)
            // pergunta qual a carta q o jogador vai usar para se defender
            // e faz a tentativa de ataque
            print("""
                        JOGADOR ATACADO
                Name:  \(currentNextPlayer.name)
                Life:  \(currentNextPlayer.life)
                Cards: [1] \(currentNextPlayer.currentIndividualsCards[0].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[0].damage)
                       [2] \(currentNextPlayer.currentIndividualsCards[1].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[1].damage)
                       [3] \(currentNextPlayer.currentIndividualsCards[2].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[2].damage)
            """
            )
            haveAttackCard(currentNextPlayer, currentCard)
            nextPlayer()

        } else {
            print("Infelizmente só 3 ou 4 jogadores poderão jogar")
            distributeCards = false
        }
    }
    // da cartas

    func giveThreeCardsToPlayers(_ giveCards: Bool) {
        if giveCards {
            for jogador in 0..<jogadores.count {
                jogadores[jogador].currentIndividualsCards = dealThreeCards(jogadores[jogador].individualsCards)
                handCards = [] // TODO: transformar em variavel local
            }

        } else {
            print("Deu erro")
        }
    }

    func giveCardsToPlayers(_ start: Bool) {
        if start {
            for jogador in 0..<jogadores.count {
                jogadores[jogador].individualsCards = dealCards()
            }
        } else {
            print("Deu erro")
        }
    }

    func defaultGamePlay(_ index: Int) {

        currentPlayer = jogadores[index]
        currentIndex = currentPlayer.id
        // define o prox jogador
        definitionNextPlayer(index, jogadores.count)
        // anuncia q o primeiro jogador deve começar
        sendMessagePlayer(currentPlayer)
        // pergunta qual a carta q o jogador vai usar para atacar
        print("""
            Name:  \(currentPlayer.name)
            Life:  \(currentPlayer.life)
            Cards: [1] \(currentPlayer.currentIndividualsCards[0].typeOfCards) Dano: \(currentPlayer.currentIndividualsCards[0].damage)
                   [2] \(currentPlayer.currentIndividualsCards[1].typeOfCards) Dano: \(currentPlayer.currentIndividualsCards[1].damage)
                   [3] \(currentPlayer.currentIndividualsCards[2].typeOfCards) Dano: \(currentPlayer.currentIndividualsCards[2].damage)
        """
        )
        askActionPlayer(currentPlayer, numberOfCard)
        // pergunta qual a carta q o jogador vai usar para se defender
        // e faz a tentativa de ataque
        print("""
            JOGADOR ATACADO
            Name:  \(currentNextPlayer.name)
            Life:  \(currentNextPlayer.life)
            Cards: [1] \(currentNextPlayer.currentIndividualsCards[0].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[0].damage)
                   [2] \(currentNextPlayer.currentIndividualsCards[1].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[1].damage)
                   [3] \(currentNextPlayer.currentIndividualsCards[2].typeOfCards) Dano: \(currentNextPlayer.currentIndividualsCards[2].damage)
        """
        )
        haveAttackCard(currentNextPlayer, currentCard)
        while jogadores.count > 1 {
            nextPlayer()
        }
    }

    func dealCards() -> [Cards] {
        var randomCards: [Cards] = []
        for _ in 0..<cards.shuffled().count {
            randomCards.append(cards.shuffled().randomElement()!)
        }
        return randomCards
    }

// FIXME: Fazer uma logica que remova os cards quando eles vao pra mao
//    func dealCards(player: Player) -> [Cards] {
//        var randomCards: [Cards] = []
//        let individualCardsShuffled = player.individualsCards.shuffled()
//        individualCardsShuffled.forEach {
//            randomCards.append(individualCardsShuffled.randomElement()!)
//            // TODO: remover card do individual
//        }
//        return randomCards
//    }

    func dealThreeCards(_ deckPlayer: [Cards]) -> [Cards] {
        for i in 0..<3 {
            handCards.append(deckPlayer[i])
        }
        return handCards
    }

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
            if currentPlayer.currentIndividualsCards.contains(where: { tipo in
                tipo.typeOfCards == .attack
            }) {
                currentCard = currentPlayer.currentIndividualsCards[numberOfCard-1]
                distributeCardsAgain(currentPlayer, numberOfCard-1)
            } else {
                distributeCardsAgain(currentPlayer, numberOfCard-1)
                while jogadores.count > 1 {
                    nextPlayer()
                }
            }
        }
    }

    // 1º Cenário: ATAQUE X DEFESA

    // tentativa de ataque no próximo jogador

    func haveAttackCard(_ nextPlayer: Player, _ currentCard: Cards) {
        if nextPlayer.currentIndividualsCards.contains(where: { tipo in
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

            print("A vida do \(currentNextPlayer.name) é: ", currentNextPlayer.life)

            if currentNextPlayer.life <= 0 {
                lostGamePlayer(currentIndexNextPlayer)
            }
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

            print("A vida do \(currentNextPlayer.name) é: ", currentNextPlayer.life)
            if currentNextPlayer.life <= 0 {
                lostGamePlayer(currentIndexNextPlayer)
            }
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
            currentCardNextPlayer = currentNextPlayer.currentIndividualsCards[numberOfCard-1]
            tryDefensePlayer(currentCardNextPlayer)
            distributeCardsAgain(currentNextPlayer, numberOfCard-1)
        }
    }

    // define a ordem dos jogadores

    func inverterDirecionamento() {
        direcionamento = direcionamento == 1 ? -1 : 1
    }

    func nextPlayer() {
        currentIndex = (currentIndex + direcionamento) % jogadores.count
        defaultGamePlay(currentIndex)
    }

    func lifePlayerUpdate(_ danoTotal: Int, _ nextPlayer: Player) -> Int {

        let lifeBeforeAttack = nextPlayer.life
        let lifeAfterAttack = lifeBeforeAttack - danoTotal
        currentNextPlayer.life = lifeAfterAttack
        return lifeAfterAttack

    }

    func updateHandCards(_ currentPlayer: Player, _ numberCard: Int) {
        var handDeckBeforeMoviment = currentPlayer.currentIndividualsCards
        let killDeck = handDeckBeforeMoviment.remove(at: numberCard)
        currentPlayer.currentIndividualsCards = handDeckBeforeMoviment
        currentPlayer.killDeck.append(killDeck)
    }

    func pullCardPlayer(_ player: Player, _ numberOfCardPlayed: Int) {
        player.currentIndividualsCards.insert(player.individualsCards[3], at: numberOfCardPlayed)
        player.individualsCards.remove(at: numberOfCardPlayed)
        let removeDeck = player.individualsCards.remove(at: 2)
        player.individualsCards.insert(removeDeck, at: numberOfCardPlayed)
    }

    func distributeCardsAgain(_ player: Player, _ numberOfCardPlayed: Int) {
        if player.individualsCards.count == 3 {
            player.individualsCards += player.killDeck
            print("deck renovado")
        } else {
            updateHandCards(player, numberOfCardPlayed)
            pullCardPlayer(player, numberOfCardPlayed)
        }
    }

    func lostGamePlayer(_ numberPlayed: Int) {
        let player = jogadores.remove(at: numberPlayed)
        print("\(player.name) nao joga mais")

//        let expectedNextIndex = (currentIndex + direcionamento) % jogadores.count
//        currentNextPlayer = jogadores[expectedNextIndex]
    }

    func inputUser() -> Int {
        let numberInputs = readLine()!
        let numberOfInputs = Int(numberInputs)!
        return numberOfInputs
    }

}
