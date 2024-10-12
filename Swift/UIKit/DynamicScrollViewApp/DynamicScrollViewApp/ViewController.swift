//
//  ViewController.swift
//  DynamicScrollViewApp
//
//  Created by 이준복 on 10/12/24.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let stackView: UIStackView = {
//       let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .lightGray
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//    
//    private let plusButton = UIButton(configuration: .filled()).then { button in
//        button.setTitle("plus", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .gray
//        
//        view.addSubview(containerView)
//        containerView.addSubview(plusButton)
//        containerView.addSubview(scrollView)
//        scrollView.addSubview(stackView)
//        
//        let offset: CGFloat = 16
//        let inset = -offset
//        
//        plusButton.addTarget(
//            self,
//            action: #selector(plusButtonTapped),
//            for: .touchUpInside
//        )
//        
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
//            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            plusButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offset),
//            plusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: inset),
//            plusButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: inset),
//            
//            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: offset),
//            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offset),
//            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: inset),
//            scrollView.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: inset),
//            scrollView.frameLayoutGuide.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
//            
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//        ])
//    }
//    
//    @objc func plusButtonTapped() {
//        stackView.addArrangedSubview(LabelView())
//    }
//
//}


import UIKit

class ViewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .lightGray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let plusButton = UIButton(configuration: .filled()).then { button in
        button.setTitle("plus", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var scrollViewHeightConstraint: NSLayoutConstraint?
    private let scrollViewMaxHeight: CGFloat = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(containerView)
        containerView.addSubview(plusButton)
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        let offset: CGFloat = 16
        let inset = -offset
        
        plusButton.addTarget(
            self,
            action: #selector(plusButtonTapped),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            plusButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offset),
            plusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: inset),
            plusButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: inset),
            
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: offset),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offset),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: inset),
            scrollView.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: inset),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        scrollViewHeightConstraint?.isActive = true
    }
    
    @objc func plusButtonTapped() {
        // LabelView() 추가
        let labelView = LabelView()
        labelView.delegate = self
        stackView.addArrangedSubview(labelView)

        updateScrollViewHeight()
    }
        
    private func updateScrollViewHeight() {
        // stackView의 전체 높이 계산
        let totalContentHeight = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        // scrollView의 높이를 동적으로 변경하고, maxHeight 이상일 때는 스크롤 활성화
        if totalContentHeight <= scrollViewMaxHeight {
            scrollViewHeightConstraint?.constant = totalContentHeight
            scrollView.isScrollEnabled = false
        } else {
            scrollViewHeightConstraint?.constant = scrollViewMaxHeight
            scrollView.isScrollEnabled = true
        }
    }
}


extension ViewController: LabelViewDelegate {
    
    func minusButtonTapped(_ view: LabelView) {
        view.removeFromSuperview()
        updateScrollViewHeight()
    }
    
}
