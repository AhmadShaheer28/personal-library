//
//  ViewController.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTF: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var authorList = [Author]()
    var selectedAuthorIndex: Int = 0
    var authorToEdit: Author?
    
    var tempAuthor = [Author]()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        addToolbarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Author"
        
        authorList = DataManager.shared.getAllAuthors()
        tempAuthor.append(contentsOf: authorList)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksVC" {
            guard let vc = segue.destination as? BookListViewController else { return }
            vc.author = authorList[selectedAuthorIndex]
            
        } else if segue.identifier == "addAuthorVC" {
            guard let vc = segue.destination as? AddAuthorViewController else { return }
            vc.author = authorToEdit
            vc.onAuthorSaved = {[weak self] in
                self?.authorList = DataManager.shared.getAllAuthors()
                self?.tableView.reloadData()
            }
            
        } else if segue.identifier == "addBookVC" {
            guard let vc = segue.destination as? AddBookViewController else { return }
            vc.onBookSaved = {[weak self] in
                self?.authorList = DataManager.shared.getAllAuthors()
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    //MARK: - Actions
    @objc func addBtnAction() { }
    
    
    //MARK: - Methods
    func createContextMenu() -> UIMenu {
        let addAuthor = UIAction(title: "Add Author", image: UIImage(systemName: "person.crop.circle")) { _ in
            self.performSegue(withIdentifier: "addAuthorVC", sender: nil)
        }
        let addBook = UIAction(title: "Add Book", image: UIImage(systemName: "book.circle")) { _ in
            self.performSegue(withIdentifier: "addBookVC", sender: nil)
        }
        return UIMenu(title: "", children: [addAuthor, addBook])
    }
    
    func addToolbarItem() {
        let addBtn = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), primaryAction: nil, menu: createContextMenu())
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        authorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "author_cell") else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(authorList[indexPath.row].firstname ?? "") \(authorList[indexPath.row].lastname ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAuthorIndex = indexPath.row
        self.performSegue(withIdentifier: "booksVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            DataManager.shared.deleteAuthor(author: self.authorList[indexPath.row])
            self.authorList = DataManager.shared.getAllAuthors()
            tableView.reloadData()
            
        }
        
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.authorToEdit = self.authorList[indexPath.row]
            self.performSegue(withIdentifier: "addAuthorVC", sender: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])

        return swipeActions
    }
    
}

extension HomeViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText",searchText)
        
        if searchText.isEmpty {
            authorList = tempAuthor
        } else {
            authorList.removeAll()
            authorList = tempAuthor.filter({ ($0.firstname?.range(of: searchText, options: .caseInsensitive) != nil) || ($0.lastname?.range(of: searchText, options: .caseInsensitive) != nil) })
            
        }
        
        tableView.reloadData()
    }
}
