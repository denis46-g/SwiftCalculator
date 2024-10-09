//
//  CalculatorController+CalculatorDelegate.swift
//  calculator
//
//  Created by Илья Лошкарёв on 20.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

extension CalculatorController: CalculatorDelegate {
    
    func calculatorDidUpdateValue(_ calculator: Calculator, with value: Double, valuePrecision fractionDigits: UInt) {
        
        print("Update Result with \(value), \(fractionDigits)")
        
        formatter.minimumFractionDigits = min(Int(fractionDigits), maximumFractionDigits)
        
        if calculator.hasPoint, fractionDigits == 0 {
            // поставили запятую, но не ввели цифры после запятой
            outputLabel.text = formatter.string(from: NSNumber(value: value))! + formatter.decimalSeparator
        } else {
            outputLabel.text = formatter.string(from: NSNumber(value: value))
        }
    }
    
    func calculatorDidClear(_ calculator: Calculator, withDefaultValue value: Double?, defaultPrecision fractionDigits: UInt?) {
        
        print("Clear")
        
        formatter.minimumFractionDigits = min(Int(fractionDigits ?? 0), maximumFractionDigits)
        
        if let inputValue = value {
            outputLabel.text = formatter.string(from: NSNumber(value: inputValue))
        } else {
            outputLabel.text = String()
        }
        
    }
    
    func calculatorDidNotCompute(_ calculator: Calculator, withError message: String) {
        
        print("Computational Error: " + message)
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel",style: UIAlertAction.Style.cancel) { action in
                alert.dismiss(animated: true, completion: nil)
            }
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func calculatorDidInputOverflow(_ calculator: Calculator) {
        
        print("Input Overflow")
        
        UIView.animate(withDuration: 0.5,
                       animations: { self.outputLabel.alpha = 0.0 },
                       completion: { (finished) in
                        UIView.animate(withDuration: 0.5) {
                            self.outputLabel.alpha = 1.0
                        }
        })
    }
    
}
