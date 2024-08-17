//
//  View.swift
//  HitTest
//
//  Created by 이준복 on 6/13/24.
//

import UIKit

extension UIView {
    var name: String { String(describing: type(of: self)) }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print()
        print(name, #function)
        print()
    }
    
}

extension UIWindow {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(name, #function)
        
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            print()
            print(name, "hit")
            print()
        }
        
        return hitView
    }
    
}


class View: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(name, #function)
        
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            print()
            print(name, "hit")
            print()
        }
        
        return hitView
    }
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print(name, #function)
//        return super.point(inside: point, with: event)
//    }
    
//    func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if !isUserInteractionEnabled || isHidden || alpha <= 0.01 {
//            return nil
//        }
//        if self.point(inside: point, with: event) {
//            for subview in subviews.reversed() {
//                let convertedPoint = subview.convert(point, from: self)
//                if let hitView = subview.hitTest(convertedPoint, with: event) {
//                    return hitView
//                }
//            }
//            return self
//        }
//        return nil
//    }
}


final class MainView: View { }
final class ViewA: View {}
final class ViewA1: View {}
final class ViewA2: View {}

final class ViewB: View {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print()
        print("Override HitTest", name)
        print()
        return self
    }
}

final class ViewB1: View {}

final class ViewB2: View {}

final class ViewC: View {}
final class ViewC1: View {}
final class ViewC2: View {}
