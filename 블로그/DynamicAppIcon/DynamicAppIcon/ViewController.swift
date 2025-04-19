//
//  ViewController.swift
//  DynamicAppIcon
//
//  Created by 이준복 on 4/19/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        setAppIcon1()
//        setAppIcon2()
    }
    
    func setAppIcon1() {
            
            let count = (UserDefaults.standard.integer(forKey: "AppIcon") + 1) % 4
            UserDefaults.standard.setValue(count, forKey: "AppIcon")
            
            var iconName: String? = nil
            switch count {
            case 1:
                iconName = "BIcon"
            case 2:
                iconName = "CIcon"
            case 3:
                iconName = "DIcon"
            default: break
            }
            
            UIApplication.shared.setAlternateIconName(iconName)
        }
    
    func setAppIcon2() {
        
        let count = (UserDefaults.standard.integer(forKey: "AppIcon") + 1) % 4
        UserDefaults.standard.setValue(count, forKey: "AppIcon")

        var appIconName: String = "AIcon"
        switch count {
        case 1:
            appIconName = "BIcon"
        case 2:
            appIconName = "CIcon"
        case 3:
            appIconName = "DIcon"
        default: break
        }
     
        setIconWithoutAlert(appIconName)
    }
    
    func setIconWithoutAlert(_ appIconName: String) {
        if let alternateIconName = UIApplication.shared.alternateIconName,
           alternateIconName == appIconName {
            return
        }

        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
            typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString, @escaping (NSError) -> ()) -> ()
            let selectorString = "_setAlternateIconName:completionHandler:"
            let selector = NSSelectorFromString(selectorString)
            let imp = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(imp, to: setAlternateIconName.self)
            method(UIApplication.shared, selector, appIconName as NSString, { _ in })
        }
    }


}

