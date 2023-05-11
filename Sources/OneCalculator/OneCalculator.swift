import ArgumentParser
import Foundation

public struct OneCalculator: ParsableCommand {
    
    public static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "onecalculator",
        abstract: "A simple calculator that takes operations on fractions as input and produces a fractional result.",
        usage: """
        * Legal operators are *, /, +, - (multiply, divide, add, subtract).
        * Operands and operators shall be separated by one or more spaces.
        * Mixed numbers shall be represented by whole&numerator/denominator; for example "3&1/4" or “-1&7/8”.
        * Improper fractions, whole numbers, and negative numbers are allowed as operands.
        
        Example runs (where ? represents the command prompt):
        ? 1/2 * 3&3/4
        = 1&7/8
        
        ? 2&3/8 + 9/8
        = 3&1/2
        
        ? 1&3/4 - 2
        = -1/4
        """,
        discussion: "",
        version: "1.0.0",
        shouldDisplay: true,
        subcommands: [Exit.self],
        defaultSubcommand: nil,
        helpNames: .shortAndLong
    )
    
    @Argument(parsing: .captureForPassthrough) var arguments: [String] = [""]
    
    public init() {}
    
    mutating public func run() throws {
        guard let input = arguments.first else { throw ValidationError("Syntax error.") }
        if input != "exit" {
            do {
                let result = try calculate(input)
                print("= \(result)")
            } catch {
                throw error
            }
        } else {
            print("Application has ended.")
            OneCalculator.exit(withError: nil)
        }
    }
    
    internal func calculate(_ input: String) throws -> String {
        let numbersAndSymbols = input.split(separator: " ")
        
        guard numbersAndSymbols.count == 3 else { throw ValidationError("Syntax error.") }
        
        let numbersInString = [numbersAndSymbols[0], numbersAndSymbols[2]]
        
        for number in numbersInString {
            guard
                number.isWholeNumber || number.isFraction
            else {
                throw ValidationError("\(number) is not a valid number of fraction.")
            }
        }
        
        guard
            let firstNumber = try? numbersInString.first?.transformExpressionToNumber(),
            let secondNumber = try? numbersInString.last?.transformExpressionToNumber()
        else {
            throw ValidationError("Runtime error.")
        }
        
        
        let symbol = numbersAndSymbols[1]
        
        guard symbol.isSymbol else { throw ValidationError("\(symbol) is not a valid symbol.")}
        
        if symbol == "/" && secondNumber == 0 {
            throw ValidationError("Cannot divide with 0.")
        }
        
        var result = ""
        
        switch symbol {
        case "+":
            result = (firstNumber + secondNumber).convertToExpression()
        case "-":
            result = (firstNumber - secondNumber).convertToExpression()
        case "/":
            result = (firstNumber / secondNumber).convertToExpression()
        case "*":
            result = (firstNumber * secondNumber).convertToExpression()
        default:
            throw ValidationError("\(symbol) is not a valid symbol.")
        }
        
        return result
    }
    
    struct Exit: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "exit",
            abstract: "Exits the application."
        )
    }
}

private extension String.SubSequence {
    var isSymbol: Bool {
        return !isEmpty && self == "*" || self == "/" || self == "+" || self == "-"
    }
    
    var isWholeNumber: Bool {
        guard !self.isEmpty else { return false }
        
        if self.first == "-" {
            return self.dropFirst().rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        } else {
            return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    var isFraction: Bool {
        if self.contains("&") {
            let expression = self.split(separator: "&")
            if let wholeNumber = expression.first, let fraction = expression.last {
                return wholeNumber.isWholeNumber && fraction.isFraction
            }
        } else {
            let expression = self.split(separator: "/")
            if let numerator = expression.first, let denominator = expression.last {
                return numerator.isWholeNumber && denominator.isWholeNumber
            }
        }
        
        return false
    }
    
    func transformExpressionToNumber() throws -> Double {
        if self.isWholeNumber {
            guard let double = Double(self) else {
                throw ValidationError("Syntax error.")
            }
            return double
        } else {
            if self.contains("&") {
                let expression = self.split(separator: "&")
                guard
                    let wholeNumber = expression.first,
                    let fraction = expression.last,
                    let wholeNumberAsDouble = Double(wholeNumber),
                    let fractionAsDouble = try? fraction.transformExpressionToNumber()
                else {
                    throw ValidationError("Syntax error.")
                }
                
                if wholeNumberAsDouble < 0 {
                    return wholeNumberAsDouble - fractionAsDouble
                } else {
                    return wholeNumberAsDouble + fractionAsDouble
                }
                
            } else {
                let expression = self.split(separator: "/")
                
                guard
                    let numerator = expression.first,
                    let denominator = expression.last,
                    let numeratorAsDouble = Double(numerator),
                    let denominatorAsDouble = Double(denominator)
                else {
                    throw ValidationError("Syntax error.")
                }
                
                return numeratorAsDouble / denominatorAsDouble
            }
        }
    }
}

private extension Double {
    func convertToExpression() -> String {
        let whole = Int(self)
        
        let (nominator, denominator) = rationalApproximation(of: self)
        let adjustedFraction = abs(nominator - (denominator * whole))
        if self == 0 {
            return "0"
        } else {
            var result = ""
            if whole != 0 {
                result += "\(whole)"
            }
            
            if adjustedFraction != 0 {
                if !result.isEmpty {
                    result += "&"
                } else if self < 0 {
                    result += "-"
                }
                result += "\(adjustedFraction)/\(denominator)"
            }
            
            return result
        }
    }
    
    func rationalApproximation(of x0 : Double, withPrecision eps : Double = 1.0E-6) -> (Int, Int) {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
}
