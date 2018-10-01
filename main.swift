// Allen ISD Computer Science Assignment
// Tic-Tac-Toe Project - Team Blue
// Ryan Jacobs, Josh Harlan, Zach Gray
// Computer Science III, Period 5
// 2018.01.31


/*

  You're responsible for winning (or at least drawing a tie) for a tic-tac-toe game.

  The input will be provided on the command line as:
  ./tic-tac-toe P abc/def/ghi [-v|--visual]

  This indicates:
    * P (required).  
      Must be either 'X' (uppercase 'X', unquoted) or 'O' (uppercase 'O', unquoted)
      Indicates the letter that the program will play.

    * abc/def/ghi (required)
      Each character corresponds to a square on the board and must be one of:
      > 'x' (lowercase 'x', unquoted)
        Indicates a square in which an 'x' has been placed.
      > 'o' (lowercase 'o', unquoted)
        Indicates a square in which an 'o' has been placed.
      > '.' (period, unquoted)
        Indicates an available square not occupied by an 'x' or an 'o'

      The board is laid out from left to right, top to bottom, i.e.:

          +---+---+---+
          | a | b | c |
          |---+---+---|
          | d | e | f |
          |---+---+---|
          | g | h | i |
          +---+---+---+

    * -v OR --visual (optional)
      Specifies that the above grid should be printed AFTER the move has been 
      calculated and AFTER the required output (described below).  
      Each box should contain a lowercase 'x' or a lowercase 'o' for each
      such option specified on the commandline, an 'X' or an 'O' in 
      accordance with the P option specified on the commandline at the position
      calculated by the program, and be empty (spaces) elsewhere.

  Unless a visual grid is indicated, the output will contain two lines:
      The first line of the output should be the same as the commandline (less 
      program name and visual option), except that the argument used for P 
      should be that of the other player, and one additional position will 
      be occupied (unless the game was already over or the board isn't 
      in a legal state, in which case no change to the grid will be output).

      
      The second line will should be one of:
      > Your turn.
      > Game over.  I won!    :)
      > Game over.  You won.  :(
      > Game over.  Tie.      :|
      > Illegal board or syntax
      

     
  As an example, given the commandline: 
    ./tic-tac-toe X x.o/.o./..x

  The response should be:
    O x.o/.o./x.x
    Your turn.


  As a second example, given the commandline:
    ./tic-tac-toe X x.o/.o./..x --visual

  The response should be:
    O x.o/.o./x.x
    Your turn.

          +---+---+---+
          | x |   | o |
          |---+---+---|
          |   | o |   |
          |---+---+---|
          | X |   | x |
          +---+---+---+

          */






import Foundation

var size = 3
func printBoard(board:Board){
    let gameBoard = board.gameBoard
    print("+---+---+---+")
    for i in 0...size-1 {
        // print(gameBoard[i][0] + gameBoard[i][1] + gameBoard[i][2])
        var line = "|"
        for j in 0...size-1 {
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
        print("+---+---+---+")
            
    }
}


// Example board to test with
var exampleBoard:[[Square]] = Array(repeating: Array(repeating: Square(mark:".", position:[-1, -1]), count: size), count: size)

var playerMove = ""
var computerMove = ""
if(CommandLine.arguments[1] == "X" || CommandLine.arguments[1] == "O") {
    computerMove = CommandLine.arguments[1]
}
else {
    assert(CommandLine.arguments[1] == "X" || CommandLine.arguments[1] == "O", "Invalid Computer Move")
}

computerMove = computerMove.lowercased()
if (computerMove == "x")
{
playerMove = "o"
}
else{
    playerMove = "x"
}

let isVisualFlag = CommandLine.arguments.indices.contains(5)
var visualFlag = false
if(isVisualFlag) {
    if(CommandLine.arguments[5] == "-v" || CommandLine.arguments[5] == "--visual") {
        visualFlag = true
    }
}



let boardSize = Int(CommandLine.arguments[3])


assert(boardSize != nil, "Must give board size.")

let winLength = Int(CommandLine.arguments[4])

assert(winLength != nil, "Must give win length.")
assert(winLength! <= boardSize!, "Win length must be less than or greater to board size.")

func outputStatus(status:String) -> Void {
    if (status == computerMove) {
        print("> Game over.  I won!    :)")
    }
    else if (status == playerMove) {
        print("> Game over.  You won.  :(")
    }
    else if (status == "*") {
        print("> Game over.  Tie.      :|")
    }
    else if (status == ".") {
        print("> Your turn.")
    }
    
}

let gameInput:String? = validateInput(input:CommandLine.arguments[2], size:boardSize!)

if (gameInput == nil) {
    print("> Illegal board or syntax")
}

assert(gameInput != nil, "Invalid Board")


var gameBoard = SmartBoard(boardString:gameInput!, size:boardSize!, winLength:winLength!, computer:computerMove, player:playerMove)
gameBoard.gameBoard = gameBoard.buildBoard()
gameBoard.analyzeBoard()
gameBoard.rank = gameBoard.ranking()
let initialRank = gameBoard.rank
/*
for i in 0..<gameBoard.antiDiags.count {
    print("New Diag")
    for j in 0..<gameBoard.antiDiags[i].count {
        print(gameBoard.antiDiags[i][j].mark)
    }
}
*/
//print(gameBoard.rank)

        


gameBoard.status = gameBoard.checkWin()


if(gameBoard.status != BoardStatus.InProgress) {
    gameBoard.outputStatus()
    gameBoard.endStatus = playerMove.uppercased() + " " + gameBoard.buildString()
    print(gameBoard.endStatus)
    if(visualFlag) {
        gameBoard.printBoard()
    }
}
else {
    gameBoard.gameBoard = gameBoard.move()
    gameBoard.rank = gameBoard.ranking()
    gameBoard.status = gameBoard.checkWin()
    gameBoard.endStatus = playerMove.uppercased() + " " + gameBoard.buildString()
    print(gameBoard.endStatus)
    gameBoard.outputStatus()
    if(visualFlag) {
        gameBoard.printBoard()
    }
}
print(initialRank)


/*
var outputBoard = exampleBoard
print(gameInput!)
outputBoard = move(sample:exampleBoard, letter:computerMove, letter2:playerMove)
*/







