import UIKit

class ViewController: UIViewController {
    
    let textField = UITextField()
    
    var textFieldYValue = CGFloat(0) // 처음 textField의 Y값
    var textFieldConstraint: NSLayoutConstraint?
    
    var calledWillShow = false
    var calledWillHide = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(textField)
        textFieldSetting()
    }
    
    func textFieldSetting() {
        textField.backgroundColor = .green
        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        textFieldConstraint = textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        textFieldConstraint?.isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        if calledWillShow {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if textFieldYValue == 0 { // 만약 willshow가 처음 호출되었다면
                textFieldYValue =  self.textField.frame.origin.y // textField의 y값을 저장
            }

            if textField.frame.origin.y == textFieldYValue { // textField의 위치가 그대로라면
                textField.frame.origin.y -= keyboardFrame.cgRectValue.height // 키보드의 크기만큼 textField를 올린다
                textField.translatesAutoresizingMaskIntoConstraints = true // 오토레이아웃 비활성화
            }
        }
        
        calledWillShow = true
        calledWillHide = false
    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        if calledWillHide {
            return
        }
        
        if textField.frame.origin.y != textFieldYValue { // textField의 위치가 바뀌엇다면
            textField.frame.origin.y = textFieldYValue // textField의 위치를 처음위치로 변경
            textField.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 활성화
        }
        
        calledWillShow = false
        calledWillHide = true
    }
}
