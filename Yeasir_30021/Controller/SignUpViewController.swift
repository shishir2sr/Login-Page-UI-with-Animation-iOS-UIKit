

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var keychainManager = KeychainManager()
    var userValidation = UserValidation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        userValidation.delegate = self
    
    }


    @IBAction func signupButtonPressed(_ sender: UIButton) {
        animateLoginButton(sender)
        userValidation.validateEmailandPass2(email: self.emailTextField.text!, pass: self.passwordTextField.text!)
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
}



// MARK: Validation Delegate
extension SignUpViewController: AnimationDelegateForVC{
    
    
    fileprivate func shakeAnimation(textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: textField.center.x - 10, y: textField.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: textField.center.x + 10, y: textField.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        textField.layer.add(shake, forKey: "position")
    }
    
    func shakeEmail(){
        shakeAnimation(textField: emailTextField)
        return
    }
    
    func shakePass(){
        shakeAnimation(textField: passwordTextField)
        return
    }
    
    func changeEmailColor(){
        self.emailTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func changePassColor(){
        self.passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    
}






extension SignUpViewController{
    fileprivate func uiUpdate() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.darkGray.cgColor
        signupButton.layer.cornerRadius = 5
    }
    
    func animateLoginButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.autoreverse, .curveEaseInOut], animations: {
            
            sender.backgroundColor = .gray
            
        }, completion: { _ in
            sender.backgroundColor = .white
            
        })
    }
}
