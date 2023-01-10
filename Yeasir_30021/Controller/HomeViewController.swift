
import UIKit

class HomeViewController: UIViewController {
    var titleText: String?
    var descriptionText: String?
    var allNotes: [Note]!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var authenticatedUser = ""
    
    @IBOutlet weak var tablveView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationFunction()
        
        
        tablveView.delegate = self
        tablveView.dataSource = self
        
        allNotes = CoreDataManager.shared.getAllNotes(email: authenticatedUser)
        
        print(allNotes.count)
      print(authenticatedUser)
    }
    
    
    @objc func logoutButtonPressed(){
        UserDefaultManager.add(key: Constants.authenTicationStatusKey, value: false)
        self.tabBarController?.tabBar.alpha = 1
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        
        self.navigationController?.popViewController(animated: true)
        
        print("Logged out: \( UserDefaultManager.read(key: Constants.authenTicationStatusKey) as! Bool)")
        
    }
    
    
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
        showAlert(sender)
        
    }
    
    
    
}


// MARK: Tableview delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = allNotes[indexPath.row].title
        cell.detailTextLabel?.text = allNotes[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {[self] _,_,_ in
            
            CoreDataManager.shared.deleteNote(index: indexPath.row, email: self.authenticatedUser)
            
            self.allNotes = CoreDataManager.shared.getAllNotes(email: self.authenticatedUser)
            self.tablveView.reloadData()
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeAction
    }
    
}


// MARK: View did load
extension HomeViewController{
    fileprivate func authenticationFunction() {
        UserDefaultManager.add(key: Constants.authenTicationStatusKey, value: true)
        
        authenticatedUser = UserDefaultManager.read(key: Constants.lastLoginKey) as! String
        
        print("authenticated user: \(authenticatedUser)")
        self.navigationItem.prompt = "Signed in as \(authenticatedUser)"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        let authStatus = UserDefaultManager.read(key: Constants.authenTicationStatusKey) as? Bool
        
        if authStatus!{
            self.tabBarController?.tabBar.alpha = 0
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
        
        PlistManager.writeToPlist(data: [authenticatedUser: "\(Date.now.formatted())"])
        let data = PlistManager.readFromPlist()
        print(data)
        
    }
    
    
}

// MARK: ALert Controller

extension HomeViewController{
    func showAlert(_ sender: Any) {
            let alertController = UIAlertController(title: "Enter Title and Description", message: "Please enter a title and a description", preferredStyle: .alert)

            // Add text field for the title
            alertController.addTextField { (textField) in
                textField.placeholder = "Title"
            }

            // Add text field for the description
            alertController.addTextField { (textField) in
                textField.placeholder = "Description"
            }

            // Add "Cancel" button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // Add "OK" button
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // Store the values from the text fields in the variables
                self.titleText = alertController.textFields?[0].text
                self.descriptionText = alertController.textFields?[1].text

                CoreDataManager.shared.addRecord(email: self.authenticatedUser, title: self.titleText!, descriptionText: self.descriptionText!, completion: { note in
                    print(note.title!)
                    
                    self.allNotes = CoreDataManager.shared.getAllNotes(email: self.authenticatedUser)
                    self.tablveView.reloadData()
                    
                })
                
            }
            alertController.addAction(okAction)

            // Show the alert controller
            present(alertController, animated: true, completion: nil)
        }
}
