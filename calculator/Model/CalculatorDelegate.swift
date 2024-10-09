//
//  Calculator.swift
//  calculator
//
//  Created by Илья Лошкарёв on 20.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation

/// Протокол делегата для калькулятора
public protocol CalculatorDelegate: class {
    
    /// Калькулятор обновил поле ввода
    func calculatorDidUpdateValue(_ calculator: Calculator, with value: Double, valuePrecision fractionDigits: UInt)

    /// Калькулятор очистил хранимые значения, установив значения по умолчанию
    func calculatorDidClear(_ calculator: Calculator, withDefaultValue value: Double?, defaultPrecision fractionDigits: UInt?)
    
    // MARK: Ошибки
    
    /// Переполнение поля ввода
    func calculatorDidInputOverflow(_ calculator: Calculator)
    
    /// Ошибка вычислений
    func calculatorDidNotCompute(_ calculator: Calculator, withError message: String)
}
