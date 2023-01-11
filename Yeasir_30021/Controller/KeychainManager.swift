
import Foundation

struct KeychainManager{
    
    // MARK: Write
    func writeToKeychain(email: String, password: String) {
        if checkIfExistsKeychain(email: email) {
            print("User already registered!")
            updateKeychain(email: email, password: password)
        }else{
            let service = "password"
           guard let data = try? JSONEncoder().encode(password) else {return}
            
            let query = [
                kSecClass : kSecClassGenericPassword,
                kSecAttrAccount: email,
                kSecAttrService: service,
                kSecValueData: data
            ] as CFDictionary
        
            SecItemAdd(query, nil)
        }
       
    }
    
    // MARK: Read
    func readDataFromKeyChain(account: String, providedPass: String) -> Bool {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: "password",
            kSecReturnData: true,
            kSecReturnAttributes: true
            
        ] as CFDictionary

        var result: CFTypeRef?

        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess, let result = result as? [CFString : Any], let data = result[kSecValueData] as? Data, let password = try? JSONDecoder().decode(String.self, from: data) else {
            return false
        }

        return password == providedPass
    }
    
    
    //MARK: Update keychain
    func updateKeychain(email: String, password: String) {
        let encodedPassword = try? JSONEncoder().encode(password)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email,
            kSecAttrService: "password"
        ] as CFDictionary
        let attributes = [
            kSecValueData: encodedPassword!,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ] as CFDictionary
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecSuccess {
            print("Successfully updated keychain item.")
        } else {
            print("Error updating keychain item:", status)
        }
    }
    
    
    // MARK: Check if user exists
    
    func checkIfExistsKeychain(email: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email,
            kSecAttrService: "password",
            kSecReturnData: true
        ] as CFDictionary
        
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }


    
    
}












/**func readDataFromKeyChain(account: String, providedPass: String) -> Bool{
    var passwordValid:Bool?
    
    let query = [
        kSecClass : kSecClassGenericPassword,
        kSecAttrAccount: account,
        kSecAttrService: "password",
        kSecReturnData: true,
        kSecReturnAttributes: true
    ] as CFDictionary
    
    var result: CFTypeRef?
    
    let status = SecItemCopyMatching(query, &result)
    
    if status == errSecSuccess {
        if let result = result as? [CFString : Any] {
            print(result[kSecValueData]!)
            print(result[kSecAttrAccount]!)
            print(result[kSecAttrService]!)
            
            if let data = result[kSecValueData] as? Data {
                let password = try? JSONDecoder().decode(String.self, from: data)
                print(password!)
                if password == providedPass{
                    print("password match!!")
                    passwordValid = true
                }
                else{
                    passwordValid = false
                    print("password not match!!")
                }
            }
        }
    } else {
//            print(status)
        passwordValid = false
    }
    
    return passwordValid!
}*/
