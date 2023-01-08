
import UIKit

class HomeViewController: UIViewController {
    var authenticatedUser: String = ""

    @IBOutlet weak var greetingLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLable.text = "Welcome!\n \(authenticatedUser)"
    }

}
