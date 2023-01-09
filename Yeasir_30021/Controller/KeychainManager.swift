
import Foundation

struct KeychainManager{
    
    // MARK: Write
    func writeToKeychain(email: String, password: String) {
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
}
