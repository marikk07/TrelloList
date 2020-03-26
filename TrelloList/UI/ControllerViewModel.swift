//
//  ControllerViewModel.swift
//  TrelloList
//
//  Created by Maryan on 26.03.2020.
//  Copyright © 2020 Marian. All rights reserved.
//

import Foundation

enum State {
    case none
    case createList
    case listViev(list: ListModel)
    case listViewEditing(list: ListModel)
    
    var rowsCount: (Int, Int) {
        switch self {
        case .none, .createList:
            return (1, 0)
        case .listViev(let listModel):
            return (listModel.filteredCardArray.count, 1)
        case .listViewEditing( _):
            return (1, 0)
        }
    }
    
    var sectionCount: Int {
        switch self {
        case .none, .createList:
            return 1
        case .listViev( _), .listViewEditing( _):
            return 2
        }
    }
    
    var sectionTitle: (String?, String?) {
        switch self {
        case .none, .createList:
            return (nil, nil)
        case .listViev(let listModel), .listViewEditing(let listModel):
            return (listModel.name, nil)
        }
    }
}

struct ControllerViewModel {
    
    var state: Box <State> = Box(.none)
    
    var listsArray: [ListModel] = []
}
