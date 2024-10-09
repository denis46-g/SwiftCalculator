//
//  CalculatorTests.swift
//  сalculatorTests
//
//  Created by mmcs on 24/09/2019.
//  Copyright © 2019 Илья Лошкарёв. All rights reserved.
//

import XCTest

class CalculatorTests: XCTestCase {

    let calc: Calculator? = nil // инстанцируйте свою модель калькулятора здесь!
    
    let epsilon = 0.0001  // точность сравнения вещественных чисел
    
    override func setUp() {
        // Этот код вызывается перед каждым тестом
    }

    override func tearDown() {
        // Этот код вызывается по окончании каждого теста
        calc?.reset()
    }
    
    func testAddDigit() {
        guard let calc = self.calc else {
            XCTFail("Калькулятор не инициализирован")
            return
        }
        
        XCTAssertNil(calc.input, "Значение по умолчанию - не пустое!")
        
        calc.addDigit(0)
        XCTAssertEqual(calc.input!, 0, accuracy: epsilon)
        
        calc.addDigit(0)
        XCTAssertEqual(calc.input!, 0, accuracy: epsilon)
        
        calc.addDigit(1)
        XCTAssertEqual(calc.input!, 1, accuracy: epsilon)
        calc.addDigit(0)
        XCTAssertEqual(calc.input!, 10, accuracy: epsilon)
        calc.addDigit(0)
        XCTAssertEqual(calc.input!, 100, accuracy: epsilon)
    }

}
