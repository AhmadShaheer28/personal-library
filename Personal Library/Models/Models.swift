//
//  Models.swift
//  Personal Library
//
//  Created on 12/12/2023.
//

import Foundation


struct PLAuthor {
    let firstname: String
    let lastname: String
}

struct PLBook {
    let title: String
    let publicationYear: String
    let synopsis: String
    let author: Author
}
