# Dynamic App Icon

특정기간이나 특정 조건에서 앱 아이콘을 바꾸고 싶을 때 앱 배포를 하지 않고 앱 아이콘을 바꾸는 방법


Assets 에 원하는 AppIcon(BIcon, CIcon, DIcon) 들을 추가
<img width="2032" alt="스크린샷 2025-04-19 오후 11 47 01" src="https://github.com/user-attachments/assets/cd46bdd6-2142-42ff-88c7-8616f4375838" />

Targets → Build Setting(All) →  Alternate App Icon Sets 에서 Assets에 추가한 AppIcon(BIcon, CIcon, DIcon) 들을 입력
<img width="2032" alt="스크린샷 2025-04-19 오후 11 47 22" src="https://github.com/user-attachments/assets/2fdf3797-7be2-4150-a761-44812742e465" />

`UIApplication.shared.setAlternateIconName(String?:)` 호출


https://github.com/user-attachments/assets/345e9eda-495d-4ce7-a5f1-4d2f496ffb33

```swift
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        setAppIcon()
    }
    
    func setAppIcon() {
        
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
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("아이콘 변경 실패: \(error)")
            } else {
                print("아이콘 변경 성공!")
            }
        }
    }
    
}
```



alert이 뜨는게 싫다면 아래 함수 호출
주의해야할 점은 appStore 심사가 거절될 수 있고
`UIApplication.shared.setAlternateIconName(String?:)`에선 nil로 값을 주면 기본으로 설정된 appIcon으로 돌아가는데
setIconWithoutAlert을 사용할 경우엔 기본으로 돌아갈 appIcon을 따로 추가해주어야 함

```swift
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
```


간혹가다 icon 변경이 안될때는 assets 이미지 이름에 icon(ex: special -> specialIcon)을 붙혀 적용해보면 변경됨
