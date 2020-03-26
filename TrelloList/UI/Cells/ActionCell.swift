//
//  ActionCell.swift
//  TrelloList
//
//  Created by Maryan on 26.03.2020.
//  Copyright © 2020 Marian. All rights reserved.
//

import UIKit

enum ActionType {
    case createList, addCard
    
    var title: String {
        switch self {
        case .createList:
            return "Create List"
        case .addCard:
            return "Add Card"
        }
    }
}

protocol ActionCellDelegate: class {
    func userAction(type: ActionType)
}

class ActionCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: ActionCellDelegate?
    
    var type: ActionType = .createList {
        didSet {
            button.setTitle(type.title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
    }

    @IBAction func buttonAction(_ sender: Any) {
        delegate?.userAction(type: type)
    }
}
