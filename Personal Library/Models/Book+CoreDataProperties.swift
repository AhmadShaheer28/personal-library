//
//  Book+CoreDataProperties.swift
//  Personal Library
//
//  Created on 13/12/2023.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var publicationYear: String?
    @NSManaged public var synopsis: String?
    @NSManaged public var title: String?
    @NSManaged public var author: Author?

}

extension Book : Identifiable {

}
