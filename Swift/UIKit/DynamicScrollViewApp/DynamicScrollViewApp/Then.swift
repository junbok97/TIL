//
//  Then.swift
//  DynamicScrollViewApp
//
//  Created by 이준복 on 10/12/24.
//

import Foundation

protocol Then {}

extension NSObject: Then {}

extension Then where Self: AnyObject {
    
    @inlinable
     func then(_ block: (Self) throws -> Void) rethrows -> Self {
       try block(self)
       return self
     }
    
}
