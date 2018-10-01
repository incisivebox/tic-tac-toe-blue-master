import Foundation

/* Matches input to a regex for a board */

func validateInput(input:String, size:Int) -> String? {
    var tictactoePattern = String(repeating: "(x|o|\\.){" + String(size) + "}\\/", count: size)
    tictactoePattern = String(tictactoePattern.dropLast())
    tictactoePattern = String(tictactoePattern.dropLast())
        //let tictactoePattern = "(x|o|\\.){3}\\/(x|o|\\.){3}\\/(x|o|\\.){3}"
        if let match = input.range(of:tictactoePattern, options: .regularExpression) {
            let test = input[match]
            let result = String(test)
            return result
        }

        else {
            print("Invalid input.")
            return nil
        }
           
    }


