//
//  CalculatorBrain.swift
//  Calculator10
//
//  Created by Brett Osler on 03/03/2017.
//  Copyright © 2017 Toasted Records. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    // MARK: - Private nested structures
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // MARK: - Private properties
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var accumulator: Double?
    
    private var operations: Dictionary<String, Operation> = [
        "x²" : Operation.unaryOperation({$0 * $0}),
        "x³" : Operation.unaryOperation({pow($0, 3.0)}),
        "y√x" : Operation.binaryOperation({pow($0, (1.0/$1))}),
        "³√" : Operation.unaryOperation({pow($0, (1.0/3.0))}),
        "√" : Operation.unaryOperation(sqrt),
        "π" : Operation.constant(Double.pi),
        
        "±" : Operation.unaryOperation({ -$0 }),
        "1/x" : Operation.unaryOperation({1.0/$0}),
        "tan" : Operation.unaryOperation(tan),
        "tan⁻¹" : Operation.unaryOperation({pow(tan($0), -1.0)}),
        "cos" : Operation.unaryOperation(cos),
        "cos⁻¹" : Operation.unaryOperation({pow(cos($0), -1.0)}),
        "sin" : Operation.unaryOperation(sin),
        "sin⁻¹" : Operation.unaryOperation({pow(sin($0), -1.0)}),
        
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        
        "=" : Operation.equals
    ]
    
    // MARK: - Private functions
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    // MARK: - PUBLIC API
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
