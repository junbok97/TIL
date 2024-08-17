//
//  MyCell.swift
//  CollectionView
//
//  Created by 이준복 on 2023/02/26.
//

import UIKit
import SnapKit

class MyCell: UICollectionViewCell {
    lazy var label: UILabel = {
       let label = UILabel()
       return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(30)
        }
    }
}
