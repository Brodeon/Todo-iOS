//
//  CategoryViewController.swift
//  Todo
//
//  Created by Przemek on 2/17/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    var context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UITableViewCell
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    @IBAction func addTodoey(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let textField = alertTextField {
                let category = Category(context: self.context)
                category.name = textField.text!
                self.categories.append(category)
                self.saveData()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Saving categories error \(error)")
        }
        
    }

    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Load categories error \(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destination = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                destination.selectedCategory = category
            }
        }
    }
 
}
