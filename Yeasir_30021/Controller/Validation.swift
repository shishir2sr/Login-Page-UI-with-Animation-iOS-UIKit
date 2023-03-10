import Foundation
import UIKit

@objc protocol AnimationDelegateForVC{
    func shakeEmail()
    func shakePass()
    func changeEmailColor()
    func changePassColor()
    @objc optional func gotoHomeScreen()
}



struct UserValidation{
    
    var delegate: AnimationDelegateForVC?
    let keychainManager = KeychainManager()
    
    
    // MARK: Validation for sign in
    func validateEmailandPass(email: String, pass: String){
        isValidEmail(email: email) ?
        delegate?.changeEmailColor() : delegate?.shakeEmail()
        isValidPassword(password: pass) ? delegate?.changePassColor() : delegate?.shakePass()
        keychainManager.readDataFromKeyChain(account: email, providedPass: pass) ? delegate?.gotoHomeScreen!() : delegate?.shakePass()
        
    }
    
    // MARK: Validation for sign up
    func validateEmailandPass2(email: String, pass: String){
        
        isValidEmail(email: email) ?
        delegate?.changeEmailColor() : delegate?.shakeEmail()
        isValidPassword(password: pass) ? delegate?.changePassColor() : delegate?.shakePass()
        keychainManager.writeToKeychain(email: email , password: pass)
        CoreDataManager.shared.addUser(email: email, completion: { person in
            print(person.email!)
            
        })
    }
    
    
    
    // MARK: Regular expressions
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        // Check if password is at least 8 characters long
        if password.count < 8 {
            return false
        }
        // Check if password contains at least one letter and one number
        let range = NSRange(location: 0, length: password.utf16.count)
        let regex = try! NSRegularExpression(pattern: ".*[A-Za-z].*[0-9]|.*[0-9].*[A-Za-z]")
        if regex.firstMatch(in: password, options: [], range: range) != nil {
            return true
        }
        return false
    }
    
}
