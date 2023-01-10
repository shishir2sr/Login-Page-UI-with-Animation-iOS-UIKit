
import Foundation
import UIKit
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    private init() {}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: Add user
    func addUser(email : String,
                 completion: (Person) -> ()) {
        
        let person = Person(context: context)
        person.email = email
        do {
            try context.save()
            completion(person)
        } catch {
            print(error)
        }
    }
    
    // MARK: Add record
    func addRecord(email: String, title: String, descriptionText: String, completion: (Note) ->()) {
        
        
        let note = Note(context: context)
        
        note.title = title
        note.note = descriptionText
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        
        do {
            let person = try context.fetch(fetchRequest).first
            person?.notes?.adding(note)
            note.author = person
            try context.save()
            completion(note)
        } catch {
            print(error)
        }
    }
    
    
//    MARK: Retrive note
    func getAllNotes(email: String) -> [Note] {
            print(email)

            var notes = [Note]()
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            do {
                let user = try context.fetch(fetchRequest).first as! Person
                notes = user.notes?.allObjects as! [Note]
            } catch {
                print("Error saving context \(error)")
            }
            return notes

        }
    
    
    
}


