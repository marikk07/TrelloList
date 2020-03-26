//
//  TextEditCell.swift
//  TrelloList
//
//  Created by Maryan on 26.03.2020.
//  Copyright © 2020 Marian. All rights reserved.
//

import UIKit

protocol TextEditCellDelegate: class {
    func updateList(_ name: String)
    func cancelAction()
}

class TextEditCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var canclButton: UIButton!
    
    weak var delegate: TextEditCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptButton.isEnabled = false
        acceptButton.alpha = 0.5
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        delegate?.updateList(textField.text ?? "")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelAction()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
}

extension TextEditCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        text = (text as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty {
            acceptButton.isEnabled = false
            acceptButton.alpha = 0.5
        } else {
            acceptButton.isEnabled = true
            acceptButton.alpha = 1.0
        }
        
        return true
    }
}
