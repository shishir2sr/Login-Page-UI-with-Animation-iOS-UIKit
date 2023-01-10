//
//  Note+CoreDataProperties.swift
//  Yeasir_30021
//
//  Created by bjit on 10/1/23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var note: String?
    @NSManaged public var author: Person?

}

extension Note : Identifiable {

}
