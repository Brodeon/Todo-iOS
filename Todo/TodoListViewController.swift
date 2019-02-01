//
//  ViewController.swift
//  Todo
//
//  Created by Przemek on 2/1/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = ["1st item", "2nd item", "3rd item"]
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = defaults.array(forKey: "items") as? [String]{
            items = array
        }
    }

    //MARK - TableView datasource metods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        let cellAccessoryType = cell.accessoryType
        
        if cellAccessoryType == .none {
            cell.accessoryType = .checkmark
        } else if cellAccessoryType == .checkmark {
            cell.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemClicked(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "Add a new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = alertTextField?.text {
                self.items.append(text)
                self.defaults.set(self.items, forKey: "items")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            alertTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

