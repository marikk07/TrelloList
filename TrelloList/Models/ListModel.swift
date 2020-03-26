//
//  ListModel.swift
//  TrelloList
//
//  Created by Maryan on 26.03.2020.
//  Copyright © 2020 Marian. All rights reserved.
//

import Foundation

struct ListModel {
    var name: String
    var id: Int64
    var filteredCardArray: [CardModel] = []
    var cardArray: [CardModel] = [] {
        didSet {
            filteredCardArray = cardArray
        }
    }
    
    init(name: String) {
        self.name = name
        self.id = Int64(Date().timeIntervalSince1970)
    }
}
