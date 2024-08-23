//
//  UIStackView+.swift
//  mall
//
//  Created by 이준복 on 8/13/24.
//

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView ...) {
        views.forEach { addArrangedSubview($0) }
    }
}
