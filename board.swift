
import Foundation

/* Old Swift 3 Substring declarations found on stackoverflow https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swifthttps://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift*/
extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}




class Board {
    var size: Int
    var winLength: Int
    var gameString: String
    var gameBoard:[[Square]]
    var status:BoardStatus = BoardStatus.InProgress
    var endStatus:String = ""
    var diagonals:[Square]
    var diagonals2:[[Square]]
    var columns:[[Square]]
    var rank:[[[Int]]]
    var computer:String
    var player:String
    var antiDiags:[[Square]] = []


    init(boardString:String, size:Int, winLength:Int, computer:String, player:String) {

        self.gameString = boardString
        self.size = size
        self.winLength = winLength
  //      print("start of code")
        self.gameBoard = Array(repeating: Array(repeating: Square(mark:".", position:[-1, -1]), count: size), count: size)
    //    print("game1")
        self.diagonals = Array(repeating: Square(mark:".", position:[-1, -1]), count: 1)
        self.diagonals2 = Array(repeating: Array(repeating: Square(mark:".", position:[-1, -1]), count: 1), count: 2*size-1)
        self.columns = Array(repeating: Array(repeating: Square(mark:".", position:[-1, -1]), count: size), count: size)

        self.computer = computer
        self.player = player
        self.rank = []

        for i in 0...(2*size-1)/2
        {
            for j in 0...i/2
            {
                diagonals2[i].append(Square(mark:".", position:[-1,-1]))
            }


        }
//        print("test1")
        for j in 0...size-2
        {
            diagonals2[size-1].append(Square(mark:".", position:[-1,-1]))
        }
      //  print("test 1.5")
        var k = size-1
        for i in size...(2*size)-1
        {
            
            for j in stride(from:k, to:0, by: -1)
            {
                diagonals2[i].append(Square(mark:".", position:[-1,-1]))
    //            print (String(i) + ", " + String(j))
            }
            k = k-1
        }
  //      print("test2")

    }

    
func buildString() -> String {
    let size = self.size
    var gamestring = ""
    for i in 0...size-1 {
        for j in 0...size-1 {
            gamestring += self.gameBoard[i][j].mark 
        }
        
        if(i == size-1) {
            return gamestring
        }
        gamestring += "/"
    }
    return "."
}

func analyzeBoard() {

    for i in 0...size-1
    {
        for j in 0...size-1
        {
            columns[i][j] = gameBoard[j][i]
        }

        
    }

    self.diagonals2 = []
    
    for i in 0..<self.gameBoard.count {
        var diagArray:[Square] = []
        for j in 0...i {
            
            diagArray.append(gameBoard[i-j][j])
        }
        
        self.diagonals2.append(diagArray)
        if (i == self.gameBoard.count-1) {
            for k in 1..<self.gameBoard.count {
                diagArray = []
                for j in 0..<self.gameBoard.count-k {
                    
                    diagArray.append(gameBoard[i-j][j+1])
                }
                self.diagonals2.append(diagArray)
            }
        }
    }

    

    for i in stride(from:self.gameBoard.count-1, to:-1, by:-1) {
        var antidiagArray:[Square] = []
        for j in 0...(self.gameBoard.count-1) - i {
            
            antidiagArray.append(gameBoard[i+j][j])
        }
        self.antiDiags.append(antidiagArray)
        if(i == 0) {
            for k in 1..<self.gameBoard.count {
                antidiagArray = []
                
                for j in 0..<self.gameBoard.count-k {
                    
                    antidiagArray.append(gameBoard[i+j][j+1])
                }
                self.antiDiags.append(antidiagArray)
            }
        }
    }

   
    //print("board analyzed")
}

func buildBoard() -> [[Square]] {
    let size = self.size
    var board = self.gameString.replacingOccurrences(of: "/", with: "")
    var boardArray = Array(board)
    var apple:[[Square]] = Array(repeating: Array(repeating: Square(mark:".", position:[-1, -1]), count: size), count: size)
    var k = 0
    for i in 0...size-1 {
        for j in 0...size-1 {
            var banana = String(boardArray[k])
            apple[i][j] = Square(mark:banana, position:[i,j])
            k += 1
        }
    }

   

    
    return apple
}

func ranking() -> [[[Int]]] {
    /* Ranks the possible win conditions based on how many marks have been placed.
     The 3D array takes the form of row, column, diag, antidiag, each containing arrays
     containing a ranking of all of the win conditions in each unit from -winLength to +winLength */


    var rankingArray: [[[Int]]] = []
    //Check rows :)
    let size = self.size
    let winLength = self.winLength
    let rowArray = self.gameBoard
    var rowRankings = Array(repeating: Array(repeating:0, count: size-(winLength - 1)), count:size)
    let computer = self.computer
    let player = self.player

    var row = 0
    var winCondition = 0
    var playerHasPlayed = false
    var computerHasPlayed = true
    for i in 0..<rowArray.count {
        for j in 0..<(size-(winLength-1)) {
            for k in j..<j+winLength {
                
                if (rowArray[i][k].mark == computer) {
                    rowRankings[row][winCondition] += 1
                    computerHasPlayed = true
                }

                else if (rowArray[i][k].mark == player) {
                    rowRankings[row][winCondition] -= 1
                    playerHasPlayed = true
                }
            }
            if (computerHasPlayed && playerHasPlayed) {
                    rowRankings[row][winCondition] = winLength + 10 //Makes ranking unwinnable
            }
            playerHasPlayed = false
            computerHasPlayed = false
            //next win condition
            winCondition += 1
        }
        //next row
        winCondition = 0
        row += 1
    }
    rankingArray.append(rowRankings)

    //Check columns :)
    let columnArray = self.columns
    var columnRankings = Array(repeating: Array(repeating:0, count: size-(winLength-1)), count:size)

    var column = 0
    winCondition = 0
    playerHasPlayed = false
    computerHasPlayed = false
    
    for i in 0..<columnArray.count {
        for j in 0..<(size-(winLength-1)) {
            for k in j..<j+winLength {
                
                if (columnArray[i][k].mark == computer) {
                    columnRankings[column][winCondition] += 1
                    computerHasPlayed = true
                }

                else if (columnArray[i][k].mark == player) {
                    columnRankings[column][winCondition] -= 1
                    playerHasPlayed = true
                }
            }
            if(computerHasPlayed && playerHasPlayed) {
                    columnRankings[column][winCondition] = winLength + 10 //Makes ranking unwinnable
            }
            playerHasPlayed = false
            computerHasPlayed = false
            //next win condition
            winCondition += 1
        }
        //next column
        winCondition = 0
        column += 1
        
    }

    rankingArray.append(columnRankings)
    
    let diagArray = self.diagonals2
    var diagRankings:[[Int]] = []
    playerHasPlayed = false
    computerHasPlayed = false
    
    
    
    for i in 0..<diagArray.count {
        diagRankings.append([])
        if (diagArray[i].count < winLength) {
            diagRankings[i].append(0)
            continue
        }
        for j in 0..<(diagArray[i].count-(winLength - 1)) {
            var value = 0
            for k in j..<j+winLength {
               
                if (diagArray[i][k].mark == computer) {
                    value += 1
                    computerHasPlayed = true
                }
                else if (diagArray[i][k].mark == player) {
                    value -= 1
                    playerHasPlayed = true
                }
                
                
                
            }
            if(computerHasPlayed && playerHasPlayed) {
                value = winLength + 10
            }
            computerHasPlayed = false
            playerHasPlayed = false
            
            diagRankings[i].append(value)
            }
    }
    

    rankingArray.append(diagRankings)

    let antidiagArray = self.antiDiags
    var antidiagRankings:[[Int]] = []

    computerHasPlayed = false
    playerHasPlayed = false
    
    
    for i in 0..<antidiagArray.count {
        antidiagRankings.append([])
        if (antidiagArray[i].count < winLength) {
            antidiagRankings[i].append(0)
            continue
        }
        for j in 0..<(antidiagArray[i].count-(winLength - 1)) {
            var value = 0
            for k in j..<j+winLength {
               
                if (antidiagArray[i][k].mark == computer) {
                    value += 1
                    computerHasPlayed = true
                }
                else if (antidiagArray[i][k].mark == player) {
                    value -= 1
                    playerHasPlayed = true
                }
                
                
                
            }
            if(computerHasPlayed && playerHasPlayed) {
                value = winLength + 10
            }
            computerHasPlayed = false
            playerHasPlayed = false
            
            antidiagRankings[i].append(value)
            }
    }
    

    rankingArray.append(antidiagRankings)

    
    
    return rankingArray
    
}

func checkWin() -> BoardStatus {
    let winnerComputer = winLength
    let winnerPlayer = -winLength
    for i in 0..<rank.count {
        for j in 0..<rank[i].count {
            for k in 0..<rank[i][j].count {
                if (rank[i][j][k] == winnerComputer) {
                    return BoardStatus.ComputerWin
                }
                else if (rank[i][j][k] == winnerPlayer) {
                    return BoardStatus.PlayerWin
                }
            }
        }
    }
    
                
    // Check for tie
    var tie = true
    for i in 0..<gameBoard.count {
        for j in 0..<gameBoard[i].count {
            if(gameBoard[i][j].mark == ".")
            {
                tie = false
                
            }
        }
    }

    if(tie)
    {
        return BoardStatus.Tie
    }
    
    return BoardStatus.InProgress
    
}

func outputStatus() -> Void {
    let status = self.status
    if (status == BoardStatus.ComputerWin) {
        print("> Game over.  I won!    :)")
    }
    else if (status == BoardStatus.PlayerWin) {
        print("> Game over.  You won.  :(")
    }
    else if (status == BoardStatus.Tie) {
        print("> Game over.  Tie.      :|")
    }
    else if (status == BoardStatus.InProgress) {
        print("> Your turn.")
    }
    
}

func printBoard(){
    let gameBoard = self.gameBoard
    let banner = String(repeating: "+---", count: size) + "+"
    print(banner)
    for i in 0..<gameBoard.count {
        // print(gameBoard[i][0] + gameBoard[i][1] + gameBoard[i][2])
        var line = "|"
        for j in 0..<gameBoard[i].count {
            if(gameBoard[i][j].mark == "x") {
                line += " X |"
            }
            else if(gameBoard[i][j].mark == "."){
                line += "   |"
            }
            else if(gameBoard[i][j].mark == "o"){
                line += " O |"
            }
            
            
        }
        print(line)
        print(banner)
            
    }
}


}


