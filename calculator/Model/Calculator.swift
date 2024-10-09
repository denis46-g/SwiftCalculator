//
//  Calculator.swift
//  calculator
//
//  Created by Илья Лошкарёв on 21.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation


/// Доступные операции
public enum Operation: String {
    case add = "+",
    sub = "-",
    mul = "×",
    div = "÷",
    sign = "±",
    perc = "%"
}


/// Протокол калькулятора
public protocol Calculator: class { // можно реализовывать только в ссылочном типе
    
    /// Представитель – объект, реагирующий на изменение внутреннего состояния калькулятора
    var delegate: CalculatorDelegate? { get set }
    
    /// Инициализатор
    /// `inputLength` – максимальная длина поля ввода (количество символов)
    /// `fractionLength` – максимальное количество знаков после запятой
    init(inputLength len: UInt, maxFraction frac: UInt)
    
    // Хранимое выражение: <левое значение> <операция> <правое значение>
    
    /// Левое значение - обычно хранит результат предыдущей операции
    var result: Double? { get }
    
    /// Текущая операция
    var operation: Operation? { get }
    
    /// Правое значение - к нему пользователь добавляет цифры
    var input: Double? { get }
    
    /// Добавить цифру к правому значению
    func addDigit(_ d: Int)
    
    /// Добавить точку к правому значению
    func addPoint()
    
    /// Правое значение содержит точку
    var hasPoint: Bool { get }
    
    /// Количество текущих знаков после запятой в правом значении
    var fractionDigits: UInt { get }
    
    /// Добавить операцию, если операция уже задана,
    /// вычислить предыдущее значение
    func addOperation(_ op: Operation)
    
    /// Вычислить значение выражения и записать его в левое значение
    func compute()
    
    /// Очистить правое значение
    func clear()
    
    /// Очистить всё выражение
    func reset()
}
