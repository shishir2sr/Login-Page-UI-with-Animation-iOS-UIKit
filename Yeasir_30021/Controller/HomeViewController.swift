
import UIKit

class HomeViewController: UIViewController {
    var authenticatedUser: String = ""

    @IBOutlet weak var greetingLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let welcomePerson = UserDefaultManager.read(key: Constants.lastLoginKey)
        self.navigationItem.prompt = "Welcome, \(welcomePerson!)"
    }

}
