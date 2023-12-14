//
//  AddAuthorViewController.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import UIKit

class AddAuthorViewController: UIViewController {

    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    
    var onAuthorSaved: (() -> Void)?
    
    var author: Author?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let author {
            title = "Edit Author"
            firstnameTF.text = author.firstname
            lastnameTF.text = author.lastname
        }
    }
    

    @IBAction func saveBtnAction(_ sender: Any) {
        let firstname = firstnameTF.text
        let lastname = lastnameTF.text
        
        if let firstname, let lastname {
            if firstname.isEmpty == true {
                showAlert(title: "Error", msg: "Please enter firstname")
                return
            } else if lastname.isEmpty == true {
                showAlert(title: "Error", msg: "Please enter lastname")
                return
            }
            
            if let author {
                DataManager.shared.updateAuthor(author: author, plAuthor: PLAuthor(firstname: firstname, lastname: lastname))
            } else {
                DataManager.shared.saveAuthor(plAuthor: PLAuthor(firstname: firstname, lastname: lastname))
            }
            
            showAlert(title: "", msg: "Data saved successfull") {_ in
                self.onAuthorSaved?()
                self.dismiss(animated: true)
            }
        }
    }

}


extension UIViewController {
    func showAlert(title: String, msg: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
}
