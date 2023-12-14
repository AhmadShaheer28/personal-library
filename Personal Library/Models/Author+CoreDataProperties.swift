//
//  Author+CoreDataProperties.swift
//  Personal Library
//
//  Created on 13/12/2023.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastname: String?
    @NSManaged public var books: Set<Book>?
    
    public var allBooks: [Book] {
        let setOfBook = books
        return (setOfBook?.sorted(by: { $0.id < $1.id }))!
    }

}

// MARK: Generated accessors for books
extension Author {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

extension Author : Identifiable {

}
