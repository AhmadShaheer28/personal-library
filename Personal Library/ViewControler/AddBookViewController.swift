//
//  AddBookViewController.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit

class AddBookViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var authorTF: UITextField!
    @IBOutlet weak var synopsisTF: UITextField!
    @IBOutlet weak var publcationYearTF: UITextField!
    
    let authorList = DataManager.shared.getAllAuthors()
    let pickerView = UIPickerView()
    
    var onBookSaved: (() -> Void)?
    var selectedAuthor: Author?
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        authorTF.inputView = pickerView
        
        if let book, let selectedAuthor {
            title = "Edit Book"
            titleTF.text = book.title
            synopsisTF.text = book.synopsis
            publcationYearTF.text = book.publicationYear
            authorTF.text = "\(selectedAuthor.firstname ?? "") \(selectedAuthor.lastname ?? "")"
        }
    }
    

    @IBAction func saveBtnAction(_ sender: Any) {
        let titleText = titleTF.text
        let publication = publcationYearTF.text
        let synopsis = synopsisTF.text
        
        if let titleText, let publication, let synopsis {
            guard let selectedAuthor else {
                showAlert(title: "Error", msg: "Please select author")
                return
            }; if titleText.isEmpty {
                showAlert(title: "Error", msg: "Please enter title")
                return
            } else if publication.isEmpty {
                showAlert(title: "Error", msg: "Please enter publication year")
                return
            } else if synopsis.isEmpty {
                showAlert(title: "Error", msg: "Please enter synopsis")
                return
            }
            
            if let book {
                DataManager.shared.updateBook(book: book, plBook: PLBook(title: titleText, publicationYear: publication, synopsis: synopsis, author: selectedAuthor))
            } else {
                DataManager.shared.addBookToSelectedAuthor(plBook: PLBook(title: titleText, publicationYear: publication, synopsis: synopsis, author: selectedAuthor))
            }
            
            showAlert(title: "Success", msg: "Data saved successfully!") {_ in
                self.onBookSaved?()
                self.dismiss(animated: true)
            }
        }
    }

}

extension AddBookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return authorList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(authorList[row].firstname ?? "") \(authorList[row].lastname ?? "")"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        authorTF.text = "\(authorList[row].firstname ?? "") \(authorList[row].lastname ?? "")"
        selectedAuthor = authorList[row]
        authorTF.resignFirstResponder()
    }
}
