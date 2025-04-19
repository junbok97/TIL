//
//  UIView+.swift
//  mall
//
//  Created by 이준복 on 8/13/24.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach { addSubview($0) }
    }
}
