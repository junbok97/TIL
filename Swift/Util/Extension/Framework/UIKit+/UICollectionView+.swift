//
//  UICollectionView+.swift
//  DongwonMall
//
//  Created by 이준복 on 8/20/24.
//

import UIKit

extension UICollectionReusableView {
    static var id: String {
        String(describing: self)
    }
}

public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: cell.id)
    }
    
    func dequeue<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cell.id, for: indexPath) as? T else {
            fatalError("Not Register Cell")
        }
        return cell
    }
    
    func registerHeader<T: UICollectionReusableView>(_ view: T.Type) {
        register(view, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.id)
    }
    
    func dequeueHeader<T: UICollectionReusableView>(_ view: T.Type, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.id, for: indexPath) as? T else {
            fatalError("Not Register ReusableView")
        }
        return view
    }
    
    func registerFooter<T: UICollectionReusableView>(_ view: T.Type) {
        register(view, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.id)
    }
    
    func dequeueFooter<T: UICollectionReusableView>(_ view: T.Type, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.id, for: indexPath) as? T else {
            fatalError("Not Register ReusableView")
        }
        return view
    }
    
}
