//
//  ViewController.swift
//  Todo
//
//  Created by Przemek on 2/1/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit
import CoreLocation

class TodoListViewController: UITableViewController {

    var items = [TodoItem]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        loadData()
        
    }

    //MARK - TableView datasource metods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.itemString
        cell.accessoryType = item.isChecked == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        selectedItem.isChecked = !selectedItem.isChecked
        tableView.reloadData()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemClicked(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "Add a new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = alertTextField?.text {
                let newItem = TodoItem()
                newItem.itemString = text
                self.items.append(newItem)
                self.saveItems()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            alertTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                self.items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("decoding error \(error)")
            }
            
        }
    }
    

}

