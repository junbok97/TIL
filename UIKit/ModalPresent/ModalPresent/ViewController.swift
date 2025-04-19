//
//  ViewController.swift
//  ModalPresent
//
//  Created by 이준복 on 11/16/23.
//

import UIKit

final class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupSheet()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ViewController {
    func setupSheet() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
        isModalInPresentation = true
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let sheetPresentationController = ViewControllertSheetPresentationController(presentedViewController: presented, presenting: source)
        sheetPresentationController.detents = [
            .small(),
            .medium(),
            .large(),
        ]
        
        sheetPresentationController.selectedDetentIdentifier = .small
        sheetPresentationController.largestUndimmedDetentIdentifier = .large
        
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        sheetPresentationController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        
        return sheetPresentationController
    }
}

final class ViewControllertSheetPresentationController: UISheetPresentationController {
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let tabBarController = presentingViewController as? UITabBarController,
              let containerView else { return }
        containerView.clipsToBounds = true
        var frame = containerView.frame
        frame.size.height -= tabBarController.tabBar.frame.height
        containerView.frame = frame
    }
}

import UIKit

extension UISheetPresentationController.Detent.Identifier {
    static let small = UISheetPresentationController.Detent.Identifier("small")
}

extension UISheetPresentationController.Detent {
    class func small() -> UISheetPresentationController.Detent {
        UISheetPresentationController.Detent.custom(identifier: .small) { 0.05 * $0.maximumDetentValue }
    }
}
