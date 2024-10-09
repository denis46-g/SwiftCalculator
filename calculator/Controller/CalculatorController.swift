//
//  CalculatorController.swift
//  calculator
//
//  Created by Илья Лошкарёв on 18.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController {

    let buttonText = [["C", "±", "%", "÷"],
                      ["7", "8", "9", "×"],
                      ["4", "5", "6", "-"],
                      ["1", "2", "3", "+"],
                      ["0", "",  ".", "="]]
    
    var outputLabel: UILabel!
    
    weak var calculator: Calculator?
    
    let formatter = NumberFormatter()
    let maximumFractionDigits = 5
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Calculator"
        initUI()
        
        // Обращаемся к созданному калькулятору
        calculator = (UIApplication.shared.delegate as! AppDelegate).calculator
        // Становимся представителем
        calculator?.delegate = self
        // Очищаем состояние калькулятора
        calculator?.reset();
        
        // Выводим число с одной цифрой
        formatter.minimumIntegerDigits = 1
    }
    
    func initUI() {
        // Reset view bounds in reference to navigation
        if let navigation = parent as? UINavigationController {
            view.bounds = CGRect(x: 0,
                                 y: navigation.toolbar.bounds.height,
                                 width: view.frame.width,
                                 height: view.frame.height -
                                    navigation.toolbar.bounds.height -
                                    UIApplication.shared.statusBarFrame.size.height)
            edgesForExtendedLayout = .bottom
        }
        
        let elementSize = CGSize(width: view.bounds.width / CGFloat(buttonText[0].count),
                                height: view.bounds.height / CGFloat(buttonText.count + 1))
        
        // LABEL
        outputLabel = UILabel(frame: CGRect(origin: view.bounds.origin,
                                      size: CGSize(width: view.bounds.width, height: elementSize.height)))
        outputLabel.text = String()
        outputLabel.textAlignment = .right
        outputLabel.font = UIFont(name: "Menlo-Regular", size: 28)
        view.addSubview(outputLabel)
        
        // BUTTONS
        for i in 0..<buttonText.count {
            for j in 0..<buttonText[i].count {
                let button = createGridButton(row: i, col: j, of: elementSize)
                button.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
    }
    
    func createGridButton(row: Int, col: Int, of size: CGSize) -> UIButton {
        
        let buttonOrigin = CGPoint(x: view.bounds.origin.x + CGFloat(col) * size.width,
                                   y: view.bounds.origin.y + CGFloat(row + 1) * size.height)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(origin: buttonOrigin, size: size)
        
        if buttonText[row][col] == "." {
            // Localized separator
            button.setTitle(formatter.decimalSeparator, for: .normal)
        } else {
            button.setTitle(buttonText[row][col], for: .normal)
        }
        
        button.titleLabel?.font = outputLabel.font.withSize(28)
        return button
    }
    
    @objc func buttonTouched(sender: UIButton)  {
        
        guard let content = sender.titleLabel?.text else {
            print("No text for touched button")
            return
        }
        
        switch content {
            
        case "0"..."9":
            calculator?.addDigit(Int(content)!)
        
        case formatter.decimalSeparator:
            calculator?.addPoint()
        
        case "C":
            if let _ = calculator?.input {
                calculator?.clear();
            } else {
                calculator?.reset();
            }
        
        case "%", "±", "+", "-", "×", "÷":
            calculator?.addOperation(Operation(rawValue:content)!)
            
        case "=":
            calculator?.compute()
            
        default:
            print("Unknown button")
        }
    }
}
