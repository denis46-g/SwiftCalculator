//
//  MyCalculator.swift
//  calculator
//
//  Created by Denis on 10/3/24.
//  Copyright © 2024 Илья Лошкарёв. All rights reserved.
//

import Foundation

func removeTrailingZeros(from string: String!) -> String {
    let trimmedString = string.replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
    return trimmedString
}

func countDecimalPlaces(of number: Double?) -> Int {
    let numberString = removeTrailingZeros(from: String(number!))
    
    if let decimalPointIndex = numberString.firstIndex(of: ".") {
        let decimalPart = numberString[numberString.index(after: decimalPointIndex)...]
        
        return decimalPart.count
    }
    
    return 0
}

/// Реализация класса калькулятора
public class MyCalculator: Calculator{
    
    /// Представитель – объект, реагирующий на изменение внутреннего состояния калькулятора
    public var delegate: CalculatorDelegate?
    
    /// Инициализатор
    /// `inputLength` – максимальная длина поля ввода (количество символов)
    /// `fractionLength` – максимальное количество знаков после запятой
    private let inputLength: UInt
    private let maxFraction: UInt
    
    public required init(inputLength len: UInt, maxFraction frac: UInt) {
        self.inputLength = len
        self.maxFraction = frac
        result = nil
        operation = nil
        input = nil
        hasPoint = false
        fractionDigits = 0
        flag_compute = false
    }
    
    // Хранимое выражение: <левое значение> <операция> <правое значение>
    
    /// Левое значение - обычно хранит результат предыдущей операции
    public var result: Double?
    
    /// Текущая операция
    public var operation: Operation?
    
    /// Правое значение - к нему пользователь добавляет цифры
    public var input: Double?
    
    /// Добавить цифру к правому значению
    public func addDigit(_ d: Int) {
        let nowInput = input ?? 0
        /*if String(format: "%.\(fractionDigits)f", nowInput).count + 1 > inputLength {
            delegate?.calculatorDidInputOverflow(self)
        }*/
        if String(nowInput).count + 1 > inputLength{
            delegate?.calculatorDidInputOverflow(self)
        }
        else {
            if !hasPoint {
                input = nowInput * 10 + Double(d)
            }
            else {
                if fractionDigits + 1 > maxFraction {
                    delegate?.calculatorDidInputOverflow(self)
                }
                else {
                    fractionDigits += 1
                    input = nowInput + Double(d)/pow(10, Double(fractionDigits))
                }
            }
        }
        delegate?.calculatorDidUpdateValue(self, with: input!, valuePrecision: fractionDigits)
    }
    
    /// Добавить точку к правому значению
    public func addPoint() {
        /*let nowInput = input ?? 0
        if String(nowInput).count + 1 > inputLength{
            delegate?.calculatorDidInputOverflow(self)
        }*/
        hasPoint = true
        delegate?.calculatorDidUpdateValue(self, with: input!, valuePrecision: fractionDigits)
    }
    
    /// Правое значение содержит точку
    public var hasPoint: Bool
    
    /// Количество текущих знаков после запятой в правом значении
    public var fractionDigits: UInt
    
    public var flag_compute: Bool
    
    /// Добавить операцию, если операция уже задана,
    /// вычислить предыдущее значение
    public func addOperation(_ op: Operation) {
        if operation == nil {
            operation = op
            if !flag_compute {
                result = input
            }
            else {
                flag_compute = false
            }
            input = nil
            delegate?.calculatorDidUpdateValue(self, with: result!, valuePrecision: fractionDigits)
        }
        else{
            /*if !flag_compute{
                compute()
            }
            else{
                flag_compute = false
            }*/
            compute()
            operation = op
            input = nil
        }
        hasPoint = false
        fractionDigits = 0
    }
    
    /// Вычислить значение выражения и записать его в левое значение
    public func compute() {
        if operation == nil {
            delegate?.calculatorDidNotCompute(self, withError: "No operation!")
        }
        else {
            switch operation! {
                case Operation.add:
                    result = result! + input!
                case Operation.sub:
                    result = result! - input!
                case Operation.mul:
                    result = result! * input!
                case Operation.perc:
                    result = result! / 100.0 * input!
                case Operation.sign:
                    if result == nil {
                        result = -input!
                    }
                    else {
                        result = -result!
                    }
                case Operation.div:
                    if input == 0 {
                        delegate?.calculatorDidNotCompute(self, withError: "Division by zero!")
                    }
                    else {
                        result = Double(result!) / Double(input!)
                    }
                }
            
                if String(format: "%.\(fractionDigits)f", result!).count > inputLength {
                    delegate?.calculatorDidInputOverflow(self)
                }
                input = nil
                operation = nil
                //clear()
                let cdp = countDecimalPlaces(of: result!)
                let c = cdp < Int(maxFraction) ? cdp : Int(maxFraction)
                hasPoint = false
                delegate?.calculatorDidUpdateValue(self, with: result!, valuePrecision: UInt(c))
                flag_compute = true
            }
    }
    
    /// Очистить правое значение
    public func clear() {
        input = nil
        hasPoint = false
        fractionDigits = 0
        delegate?.calculatorDidUpdateValue(self, with: 0, valuePrecision: fractionDigits)
    }
    
    /// Очистить всё выражение
    public func reset() {
        result = nil
        operation = nil
        hasPoint = false
        fractionDigits = 0
        delegate?.calculatorDidUpdateValue(self, with: 0, valuePrecision: fractionDigits)
        //delegate?.calculatorDidClear(self, withDefaultValue: 0, defaultPrecision: 0)
    }
}
