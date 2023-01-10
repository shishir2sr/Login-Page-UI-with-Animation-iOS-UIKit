
import Foundation
struct UserDefaultManager{

    // MARK:  Add
    static func add(key: String, value: Any) {
            UserDefaults.standard.set(value, forKey: key)
    }

    // MARK:  Read
    static func read(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }

    // MARK: Delete
    static func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: Update
    static func update(key: String, value: Any) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(value, forKey: key)
    }

    // MARK: Clear
    static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    // MARK:  Check if key exists
    static func keyExists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
