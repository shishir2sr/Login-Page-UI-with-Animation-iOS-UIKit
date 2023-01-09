
import UIKit

class HomeViewController: UIViewController {
    var authenticatedUser: String = ""

    @IBOutlet weak var greetingLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let welcomePerson = UserDefaultManager.read(key: Constants.lastLoginKey)
        self.navigationItem.prompt = "Welcome, \(welcomePerson!)"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        self.tabBarController?.tabBar.alpha = 0
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        
    }
    

    
    @objc func logoutButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
}
