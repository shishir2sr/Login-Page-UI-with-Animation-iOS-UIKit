import Foundation
import UIKit

protocol AnimationDelegateForVC{
    func shakeEmail()
    func shakePass()
    func changeEmailColor()
    func changePassColor()
}

struct UserValidation{
    
    var delegate: AnimationDelegateForVC?
    
    
    
    func validateEmailandPass(email: String, pass: String){
        
        isValidEmail(email: email) ?
        delegate?.changeEmailColor() : delegate?.shakeEmail()
        
        isValidPassword(password: pass) ? delegate?.changePassColor() : delegate?.shakePass()
    }
    
    
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
