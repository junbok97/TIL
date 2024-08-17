//
//  ViewController.swift
//  CollectionView
//
//  Created by 이준복 on 2023/02/26.
//

import UIKit
import SwiftUI
import SnapKit

class ViewController: UIViewController {
    
    let firstbackground = "firsbackground"
    let secondbackground = "secondbackground"
    let thirdbackground = "thirdbackground"
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        return collectionView
    }()
    
    let colors: [UIColor] = [.red, .yellow, .green]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionViewConstraints()
    }

}

// MARK: - AutoLayout
extension ViewController {
    func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


// MARK: - UICollectionViewLayout
extension ViewController {
    
    func makeLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionNum, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch sectionNum {
            case 0:
                return self.firstSection()
            case 1:
                return self.secondSection()
            default:
                return self.thirdSection()
            }
        }
        
        layout.register(FirstSectionBackground.self, forDecorationViewOfKind: firstbackground)
        layout.register(SecondSectionBackground.self, forDecorationViewOfKind: secondbackground)
        layout.register(ThirdSectionBackground.self, forDecorationViewOfKind: thirdbackground)
        
        return layout
        
    }
    
    func firstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionBackgroud = NSCollectionLayoutDecorationItem.background(elementKind: firstbackground)
        section.decorationItems = [sectionBackgroud]
        
        return section
        
    }
    
    func secondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
        
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let sectionBackgroud = NSCollectionLayoutDecorationItem.background(elementKind: secondbackground)
        section.decorationItems = [sectionBackgroud]
        
        return section
    }

    
    func thirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let sectionBackgroud = NSCollectionLayoutDecorationItem.background(elementKind: thirdbackground)
        section.decorationItems = [sectionBackgroud]
        
        return section
    }
    
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else { return UICollectionViewCell() }
        cell.backgroundColor = colors[indexPath.section]
        cell.label.text = indexPath.row.description
        return cell
    }
    
    

}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - SwiftUI를 활용한 미리보기
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        
        
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = ViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}



