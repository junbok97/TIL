//
//  LabelView.swift
//  DynamicScrollViewApp
//
//  Created by 이준복 on 10/12/24.
//

import UIKit

protocol LabelViewDelegate: AnyObject {
    func minusButtonTapped(_ view: LabelView)
}


final class LabelView: UIView {
    
    static var count: Int = 0
    
    weak var delegate: LabelViewDelegate?

    private let label = UILabel().then { label in
        label.text = "\(LabelView.count) Label"
        LabelView.count += 1
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let minusButton = UIButton(configuration: .filled()).then { button in
        button.setTitle("minus", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(label)
        addSubview(minusButton)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            minusButton.topAnchor.constraint(equalTo: topAnchor),
            minusButton.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor),
            minusButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            minusButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        minusButton.addTarget(
            self,
            action: #selector(minusButtonTapped),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func minusButtonTapped() {
        delegate?.minusButtonTapped(self)
    }
    
}
