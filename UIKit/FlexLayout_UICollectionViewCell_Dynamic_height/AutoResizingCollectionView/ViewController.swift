//
//  ViewController.swift
//  AutoResizingCollectionView
//
//  Created by Andrea Toso on 05/01/18.
//  Copyright © 2018 Andrea Toso. All rights reserved.
//

import UIKit
import FlexLayout


let samuelQuotes = [
    "Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.",
    "Well, the way they make shows is, they make one show. That show's called a pilot.",
    "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there.",
    "The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men.",
    "And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers. And you will know My name is the Lord when I lay My vengeance upon thee."
]


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private(set) var collectionView: UICollectionView
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.size.width
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: width, height: 50)
        return layout
    }()


    // Initializers
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Dynamic size sample"
        
        collectionView.register(Cell_1.self, forCellWithReuseIdentifier: "cell_1")

        
        view.addSubview(collectionView)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        // Setup Autolayout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self

        
    }

    // MARK: - UICollectionViewDataSource -
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_1", for: indexPath) as! Cell_1
        cell.initCell(title: "Number cell for collectionView - \(indexPath.item)", array: samuelQuotes)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samuelQuotes.count
    }

     //MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 50
        let referenceWidth = collectionView.frame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }) { (completed) in


        }


    }
    
}


class Cell_1: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initCell(title: String, array: [String]?) {
        self.arrayString = array
        label.text = title
        label.flex.markDirty()
        
        collectionView.frame.size.width = UIScreen.main.bounds.width - 32
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        collectionView.flex.height(collectionView.collectionViewLayout.collectionViewContentSize.height)
        
        layout()
    }
    
    private var prototype: Cell_2!
    
    private var arrayString: [String]?
    
    private(set) var collectionView: UICollectionView!
    private var label: UILabel!
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.size.width - 32
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: width, height: 50)
        return layout
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prototype = Cell_2()
        backgroundColor = .lightGray
        
        
        label = UILabel()
        label.numberOfLines = 0
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(Cell_2.self, forCellWithReuseIdentifier: "cellId")
        collectionView.alwaysBounceVertical = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.delegate = self
        
        contentView.flex.padding(8, 16, 8, 16).define { (flex) in
            flex.addItem(label)
            flex.addItem(collectionView).marginTop(10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayString?.count ?? 0
    }
    
    
    // MARK: - UICollectionViewDataSource -
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Cell_2
        cell.initCell(title: arrayString?[indexPath.item])
        return cell
    }
    
    
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceWidth = collectionView.frame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        
        prototype.contentView.frame.size.width = referenceWidth
        prototype.initCell(title: arrayString?[indexPath.item])
        prototype.layout()
        return prototype.contentView.frame.size
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        layout()
        return contentView.frame.size
    }
}

class Cell_2: UICollectionViewCell {
    
    
    func initCell(title: String?) {
        label.text = title
        label.flex.markDirty()
        layout()
    }
    
    
    private var label: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        
        label = UILabel()
        label.numberOfLines = 0
        
        contentView.flex.define { (flex) in
            flex.addItem(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        layout()
        return contentView.frame.size
    }

    
    func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
}



