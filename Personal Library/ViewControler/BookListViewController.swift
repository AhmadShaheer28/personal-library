//
//  BookListViewController.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit

class BookListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var author: Author?
    var bookList = [Book]()
    var selectedBookToEdit: Book?
    
    var tempBook = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        
        if let author {
            bookList = author.allBooks
            tempBook.append(contentsOf: bookList)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBookVC" {
            guard let vc = segue.destination as? AddBookViewController else { return }
            vc.selectedAuthor = author
            vc.book = selectedBookToEdit
            vc.onBookSaved = {[weak self] in
                self?.tableView.reloadData()
            }
        }
    }

}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "book_cell") as? BookTableViewCell else { return UITableViewCell() }
        cell.titleLbl.text = bookList[indexPath.row].title
        cell.publicationLbl.text = bookList[indexPath.row].publicationYear
        cell.synopsisLbl.text = bookList[indexPath.row].synopsis
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            DataManager.shared.deleteBook(book: self.bookList[indexPath.row])
            self.bookList.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.selectedBookToEdit = self.bookList[indexPath.row]
            self.performSegue(withIdentifier: "editBookVC", sender: nil)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])

        return swipeActions
    }
    
}

extension BookListViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText",searchText)
        
        if searchText.isEmpty {
            bookList = tempBook
        } else {
            bookList.removeAll()
            bookList = tempBook.filter({ ($0.title?.range(of: searchText, options: .caseInsensitive) != nil) })
            
        }
        
        tableView.reloadData()
    }
}
