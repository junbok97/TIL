//
//  NaviVC.swift
//  Test
//
//  Created by 이준복 on 6/8/24.
//

import UIKit

final class NaviVC: UINavigationController { 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function, String(describing: type(of: self)))
        super.touchesBegan(touches, with: event)
    }
    
}
