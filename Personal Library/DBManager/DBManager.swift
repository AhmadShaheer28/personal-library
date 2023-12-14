//
//  DBManager.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit
import CoreData


class DataManager: NSObject {
    fileprivate let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context: NSManagedObjectContext {
        return delegate.persistentContainer.viewContext
    }
    
    static let shared = DataManager()
    
    func saveAuthor(plAuthor: PLAuthor) {
        let author = Author(context: context)
        author.id = UUID()
        author.firstname = plAuthor.firstname
        author.lastname = plAuthor.lastname
        
        do {
            try context.save()
        } catch {
            print("Error saving author: \(error.localizedDescription)")
        }
    }
    
    func getAllAuthors() -> [Author] {
        
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Author.firstname, ascending: true)]
        
        do {
            let data = try context.fetch(fetchRequest)
            return data
            
        } catch let error {
            print("Author data error: ", error.localizedDescription)
        }
        
        return []
    }
    
    func updateAuthor(author: Author, plAuthor: PLAuthor) {
        author.firstname = plAuthor.firstname
        author.lastname = plAuthor.lastname
        
        do {
            try context.save()
        } catch let error {
            print("Author update error: ", error.localizedDescription)
        }
    }
    
    func deleteAuthor(author: Author) {
        context.delete(author)
        
        do {
            try context.save()
        } catch let error {
            print("Author deletion error: ", error.localizedDescription)
        }
    }
    
    func addBookToSelectedAuthor(plBook: PLBook) {
        let book = Book(context: context)
        book.id = UUID()
        book.title = plBook.title
        book.publicationYear = plBook.publicationYear
        book.synopsis = plBook.synopsis
        
        plBook.author.addToBooks(book)
        
        do {
            try context.save()
        } catch {
            print("Error saving book: \(error.localizedDescription)")
        }
    }
    
    func updateBook(book: Book, plBook: PLBook) {
        book.title = plBook.title
        book.publicationYear = plBook.publicationYear
        book.synopsis = plBook.synopsis
        
        plBook.author.addToBooks(book)
        
        do {
            try context.save()
        } catch let error {
            print("Author update error: ", error.localizedDescription)
        }
    }
    
    func deleteBook(book: Book) {
        context.delete(book)
        
        do {
            try context.save()
        } catch let error {
            print("Author deletion error: ", error.localizedDescription)
        }
    }
}
