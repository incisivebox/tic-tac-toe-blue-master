class SmartBoard: Board {
    func move() -> [[Square]] {
    var gameBoard = self.gameBoard

    var ranknum = self.winLength * -1
    while ranknum <= -1 {
        for i in stride(from:rank.count-1, to:0, by:-1) {
            for j in 0..<rank[i].count {
                for k in 0..<rank[i][j].count {
                    if(rank[i][j][k] == self.winLength - 1) {
                        var computerBoard:[[Square]]?
                        if let computerBoard = makeComputerMove(elementType:i, element:j, winCondition:k) {
                            return computerBoard
                        }
                    }
                    else if(rank[i][j][k] == ranknum) {
                        var computerBoard:[[Square]]?
                        if let computerBoard = makeComputerMove(elementType:i, element:j, winCondition:k) {
                            return computerBoard
                        }
                    }
                }
            }
        }
        ranknum += 1
    }

    for i in 0..<gameBoard.count {
        for j in 0..<gameBoard[i].count {
            if (gameBoard[i][j].mark == ".") {
                gameBoard[i][j].mark = self.computer
                return gameBoard
            }
        }
    }

    //print("No moves found.")
    return gameBoard
            
            

    
    }

    func makeComputerMove(elementType:Int, element:Int, winCondition:Int) -> [[Square]]? {
        var gameBoard = self.gameBoard
        if (elementType == 0) {
            for i in winCondition..<winCondition+winLength {
                if (gameBoard[element][i].mark == ".") {
                    gameBoard[element][i].mark = self.computer
                    return gameBoard
                }
            }
        }

        
        
        if (elementType == 1) {
            for i in winCondition..<winCondition+winLength {
                if(columns[element][i].mark == ".") {
                    let posX = columns[element][i].position[0]
                    let posY = columns[element][i].position[1]
                    gameBoard[posX][posY].mark = self.computer
                    return gameBoard
                }
            }
        }

        let diagonals = self.diagonals2
        if (elementType == 2) {
            for i in winCondition..<winCondition+winLength {
                if(diagonals[element][i].mark == ".") {
                    let posX = diagonals[element][i].position[0]
                    let posY = diagonals[element][i].position[1]
                    gameBoard[posX][posY].mark = self.computer
                    return gameBoard
                }
            }
        }

        let antidiagonals = self.antiDiags
        if (elementType == 3) {
            for i in winCondition..<winCondition+winLength {
                if(antidiagonals[element][i].mark == ".") {
                    let posX = antidiagonals[element][i].position[0]
                    let posY = antidiagonals[element][i].position[1]
                    gameBoard[posX][posY].mark = self.computer
                    return gameBoard
                }
            }
        }


        

        return nil
    }
    
}
