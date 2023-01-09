
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var snowfallingImage: UIImageView!
    @IBOutlet weak var snowFallingImage2: UIImageView!
    @IBOutlet weak var snowFallingImage2CenterY: NSLayoutConstraint!
    @IBOutlet weak var snowFallImageContraintX: NSLayoutConstraint!
    @IBOutlet weak var snowFallImageConstraintY: NSLayoutConstraint!
    @IBOutlet weak var gearImage: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var lastLoginEmail:String?
    
    let keychainManager = KeychainManager()
    var userValidation = UserValidation()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiChange()
        userValidation.delegate = self
        
        lastLoginEmail = UserDefaultManager.read(key: Constants.lastLoginKey) as? String
        
        emailTextField.text = lastLoginEmail ?? ""
        
       var authStatus = UserDefaultManager.read(key: Constants.authenTicationStatusKey) as! Bool
       authStatus  ? gotoHomeScreen() : print("User not authenticated, Please login")
    }
    
    //prepare for seque
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            if segue.identifier == "s1"{
//                let vc = segue.destination as! HomeViewController
//
//
//            }
//        }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        animateLoginButton(sender)
        UserDefaultManager.add(key: Constants.lastLoginKey, value: emailTextField.text!)
        userValidation.validateEmailandPass(email: self.emailTextField.text!, pass: self.passwordTextField.text!)
        passwordTextField.text = ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageCenterMove()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSnowFall()
        
    }
    
    
}




// MARK: Animation functions
extension ViewController{
    func imageCenterMove(){
        
        self.snowfallingImage.alpha = 0.8
        self.snowFallingImage2.alpha = 0
        
        self.snowfallingImage.center = CGPoint(x:  -(self.view.bounds.width), y:  +(self.view.bounds.height))
        
        //        self.snowFallingImage2.center = CGPoint(x:  -(self.view.bounds.width), y:  +(self.view.bounds.height))
        snowFallingImage2CenterY.constant -= view.bounds.width
        
//        loginView.center.x -= self.view.bounds.width
        
    }
    
    
    func animateSnowFall(){
        UIView.animate(withDuration: 5 , delay: 0.2 , options: [.repeat, .curveEaseOut], animations: { [weak self] in
            guard let self = self else{return}
            self.snowfallingImage.alpha = 0.0
            
            self.snowfallingImage.center = CGPoint(x: self.view.bounds.width , y:  self.view.bounds.height )
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        //        UIView.animate(withDuration: 3, delay: 0.0, options: [.repeat], animations: {[weak self] in
        //                    guard let self = self else{return}
        //                    self.gearImage.transform = self.gearImage.transform.rotated(by: CGFloat(Double.pi/2))
        //                }, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.gearImage.transform = self.gearImage.transform.rotated(by: CGFloat(Double.pi/8))
        }
        
        UIView.animate(withDuration: 8, delay: 0, animations: {[weak self] in
            guard let self = self else{return}
            self.snowFallingImage2.alpha = 1
            self.snowFallingImage2CenterY.constant = 0
        })
//        UIView.animate(withDuration: 1, delay: 0.0, options: [.transitionCurlDown, .curveEaseOut], animations: {[self] in
//            self.loginView.center.x = 0
//
//        }, completion: nil)
        
        
        
    }
}



//MARK: Validation
extension ViewController: AnimationDelegateForVC{
    
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
    
    @objc func gotoHomeScreen() {
        UserDefaultManager.add(key: Constants.lastLoginKey, value: emailTextField.text!)
        performSegue(withIdentifier: "s1", sender: nil)
    }
    
}





// MARK: UI
extension ViewController{
    fileprivate func uiChange() {
        loginView.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.darkGray.cgColor
        loginButton.layer.cornerRadius = 5
    }
    
    
    fileprivate func animateLoginButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.autoreverse, .curveEaseInOut], animations: {
            
            sender.backgroundColor = .gray
            
        }, completion: { [self] _ in
            self.loginButton.backgroundColor = .white
            
        })
    }
}


