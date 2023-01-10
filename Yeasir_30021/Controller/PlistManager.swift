
import Foundation
struct PlistManager{
    
  
    
    static func readFromPlist() -> (String?) {
        let plistPath = Bundle.main.path(forResource: "myplist", ofType: "plist")
        let data = NSDictionary(contentsOfFile: plistPath!)
        let log = data?["log"] as? String
        print(log)
        return (log)
    }
    
    

    static func writeToPlist(data: [String: Any], filepath: String = "myplist.plist") {
        let plistPath =  Bundle.main.path(forResource: "myplist", ofType: "plist")
        guard let plistPath = plistPath else {return}
        let fileUrl = URL(fileURLWithPath: plistPath)
        
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try plistData.write(to: fileUrl)
            print("Data written to \(filepath)")
        } catch {
            print("Error writing plist: \(error)")
        }
    }
    
    func readFromPlist(filepath: String = "myplist.plist") -> [String: Any]? {
        let plistPath =  Bundle.main.path(forResource: "myplist", ofType: "plist")
        guard let plistPath = plistPath else {return nil}
        
        let fileUrl = URL(fileURLWithPath: plistPath)
        
        do {
            let plistData = try Data(contentsOf: fileUrl)
            let data = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: nil) as! [String: Any]
            print("Data read from \(filepath): \(data)")
            return data
        } catch {
            print("Error reading plist: \(error)")
            return nil
        }
    }




    
}
