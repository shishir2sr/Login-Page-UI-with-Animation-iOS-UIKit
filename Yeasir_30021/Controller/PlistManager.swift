
import Foundation
struct PlistManager{
    
    // MARK: Write to plist
    static func writeToPlist(data: [String: Any]) {
        // creating the URL for the plist file
        
        guard let resourceDirPath = Bundle.main.resourcePath else { return }
        print(resourceDirPath)
        let plistPath = resourceDirPath.appending("/myplist.plist")
        let filePath = URL(fileURLWithPath: plistPath)
        print("Plist filepath: \(filePath)")
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try data.write(to: filePath)
            print("plist data added")
        } catch {
            print(error)
        }
        
    }
    
    
    // MARK:  Read from Plist
    static func readFromPlist() -> [String : Any]? {
        
        guard let resourceDirPath = Bundle.main.resourcePath else {return nil}
        print(resourceDirPath)
        let plistPath = resourceDirPath.appending("/myplist.plist")
        let filePath = URL(fileURLWithPath: plistPath)
        
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        
        guard var plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String : Any] else { return nil }
        
        return plist
    }


    
}
