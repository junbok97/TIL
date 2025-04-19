//
//  AppDelegate.swift
//  UIResponder
//
//  Created by 이준복 on 6/9/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function, String(describing: type(of: self)))
        super.touchesBegan(touches, with: event)
    }

}
