//
//  ViewController.swift
//  TrelloList
//
//  Created by Maryan on 26.03.2020.
//  Copyright © 2020 Marian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var model: ControllerViewModel = ControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        tableView.tableFooterView = UIView(frame: .zero)
        model.state.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func rightSwipeAction(_ sender: Any) { // minus index --
        searchBar.text = nil
        view.endEditing(true)
        switch model.state.value {
        case .listViev(let list):
            var index = model.listsArray.firstIndex(where: {$0.id == list.id}) ?? 0
            index -= 1
            model.state.value = index >= 0 ? .listViev(list: model.listsArray[index]) : .none
        default: break
        }
    }
    
    @IBAction func leftSwipeAction(_ sender: Any) { // plus index ++
        searchBar.text = nil
        view.endEditing(true)
        switch model.state.value {
        case .none:
            let index = 0
            guard index < model.listsArray.count else { return }
            model.state.value = .listViev(list: model.listsArray[index])
        case .listViev(let list):
            var index = model.listsArray.firstIndex(where: {$0.id == list.id}) ?? 0
            index += 1
            guard index < model.listsArray.count else { return }
            model.state.value = .listViev(list: model.listsArray[index])
        default: break
        }
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        view.endEditing(true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        model.state.value.sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? model.state.value.rowsCount.self.0 : model.state.value.rowsCount.self.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return prepareCellWith(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? model.state.value.sectionTitle.self.0 : model.state.value.sectionTitle.self.1
    }
    
    private func prepareCellWith(indexPath: IndexPath) -> UITableViewCell {
        switch model.state.value {
        case .none:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.actionCell, for: indexPath) as? ActionCell {
                cell.delegate = self
                cell.type = .createList
                
                return cell
            }
        case .createList:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.textEditCell, for: indexPath) as? TextEditCell {
                cell.delegate = self
                
                return cell
            }
            
        case .listViev(let list):
            if indexPath.section == 1, let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.actionCell, for: indexPath) as? ActionCell {
                cell.delegate = self
                cell.type = .addCard
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.basicCell, for: indexPath)
                cell.textLabel?.text = list.filteredCardArray[indexPath.row].name
                
                return cell
            }
            
        case .listViewEditing( _):
            if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.textEditCell, for: indexPath) as? TextEditCell {
                cell.delegate = self
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension ViewController: ActionCellDelegate {
    func userAction(type: ActionType) {
        if type == .createList {
            model.state.value = .createList
        } else {
            switch model.state.value {
            case .listViev(let list):
                model.state.value = .listViewEditing(list: list)
            case .listViewEditing(let list):
                model.state.value = .listViev(list: list)
            default: break
            }
        }
    }
}

extension ViewController: TextEditCellDelegate {
    func updateList(_ name: String) {
        switch model.state.value {
        case .createList:
            let list = ListModel(name: name)
            model.state.value = .listViev(list: list)
            model.listsArray.append(list)
        case .listViewEditing(let list):
            guard let index = model.listsArray.firstIndex(where: {$0.id == list.id}) else { return }
            let card = CardModel(name: name)
            var updatedList = list
            updatedList.cardArray.append(card)
            model.state.value = .listViev(list: updatedList)
            model.listsArray[index] = updatedList
        default: break
        }
    }
    
    func cancelAction() {
        switch model.state.value {
        case .createList:
            model.state.value = .none
        case .listViewEditing(let list):
            model.state.value = .listViev(list: list)
        default: break
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        switch model.state.value {
        case .listViev( _):
            return true
        default: return false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch model.state.value {
        case .listViev(let listModel):
            var filteredList = listModel
            if searchText.count > 0 {
                filteredList.filteredCardArray = filteredList.cardArray.filter({$0.name.contains(searchText)})
            } else {
                filteredList.filteredCardArray = filteredList.cardArray
            }

            model.state.value = .listViev(list: filteredList)
        default: break
        }
    }
}
