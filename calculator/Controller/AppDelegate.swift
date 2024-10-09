//
//  AppDelegate.swift
//  calculator
//
//  Created by Илья Лошкарёв on 18.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var calculator: Calculator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UINavigationController - отображает название текущего контролера
        // и позволяет пользователю переходить назад, по стеку контролеров
        let navigation = UINavigationController(rootViewController: CalculatorController())
        navigation.view.backgroundColor = UIColor.white
        
        // Устанавливаем контроллер для отображения на экране
        window?.rootViewController = navigation
        
        // Инициализируем обработку ввода пользоыателя
        window?.makeKeyAndVisible()
        
        /////////////////////
                           //
        calculator = MyCalculator(inputLength: 10, maxFraction: 5)   // инстанцируйте свою модель калькулятора здесь!
                           //
        /////////////////////
        
        return true
    }
}

