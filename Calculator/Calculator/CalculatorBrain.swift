//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Cory Steers on 5/1/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import Foundation

// struct CalculatorBrain: CustomStringConvertible { // if I want to play with CustomStringConvertible protocol
struct CalculatorBrain {
    
    mutating func addUnaryOperation(named symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
    private var accumulator: (double: Double, log: [String])?
//    private var log: [String] = []
    let elipseCharacterSet = CharacterSet(charactersIn: "…")
    private var lastOperation = LastOperation.clear
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private enum LastOperation {
        case digit
        case constant
        case unaryOperation
        case binaryOperation
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(.pi),
        "e":  Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "x²": Operation.unaryOperation({ $0 * $0 }),
        "x³": Operation.unaryOperation({ $0 * $0 * $0 }),
        "¹/x": Operation.unaryOperation({ 1 / $0 }),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if accumulator == nil {
                    accumulator = (value, log: [symbol])
                } else {
                    accumulator?.log.append(symbol)
                    accumulator?.double = value
                }
                lastOperation = .constant
                
            case .unaryOperation(let function):
                
                wrapWithParens(operand: symbol)
                let answer = function(accumulator!.double)
                accumulator?.double = answer
                lastOperation = .unaryOperation
                
            case .binaryOperation(let function):
                
                if lastOperation == .equals {
                    accumulator?.log.removeLast()
                }
                accumulator?.log.append(symbol)
                performPendingBinaryOperation()
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!.double)
                lastOperation = .binaryOperation
                
            case .equals:
                
                accumulator?.log.append(symbol)
                performPendingBinaryOperation()
                lastOperation = .equals
                
            case .clear:
                lastOperation = .clear
                clearPendingBinaryOperation()
            }
            
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator!.double = pendingBinaryOperation!.perform(with: accumulator!.double)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if accumulator != nil {
            accumulator!.double = operand
            if accumulator?.log != nil {
                if lastOperation == .unaryOperation {
                    accumulator?.log.removeAll()
                }
                accumulator?.log.append(String(operand))
            }
        } else {
            accumulator = (operand, log: [String(operand)])
        }
    }
    
    var result: Double {
        get {
            if let accum = accumulator {
                return accum.double
            }
            return 0
        }
    }
    
    mutating func clearPendingBinaryOperation() {
        pendingBinaryOperation = nil
        accumulator = nil
        lastOperation = .clear
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var description: String {
        get {
            if pendingBinaryOperation != nil {
                return (accumulator?.log.joined(separator: " "))! + " …"
            }
            if let accum = accumulator {
                return accum.log.joined(separator: " ")
            }
            return " "
        }
        set {
            if newValue == "" || newValue == " " {
                accumulator?.log = []
            } else {
                accumulator?.log.append(String(newValue))
            }
        }
    }
    
    private mutating func wrapWithParens(operand: String) {
        if var log = accumulator?.log {
            if lastOperation == .equals {
                log.insert(")", at: log.count - 1)
                log.insert("(", at: 0)
                log.insert(operand, at: 0)
            } else {
                log.insert(operand, at: log.count - 1)
                log.insert("(", at: log.count - 1)
                log.insert(")", at: log.count)
            }
            accumulator?.log = log
        }
    }
}
