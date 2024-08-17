//
//  SecondSectionBackground.swift
//  CollectionView
//
//  Created by 이준복 on 2023/02/26.
//

import UIKit

class SecondSectionBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
