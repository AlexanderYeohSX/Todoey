//
//  ViewController.swift
//  Todoey
//
//  Created by Kean Wei Wong on 18/12/2018.
//  Copyright © 2018 Kean Wei Wong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items
        }
        
    }
    
    // MARK - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    // MARK - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       // if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            
            
            
       // } else {
            
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //}
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
      
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let todoItem = textField.text
            {
                let newItem = Item()
                
                newItem.title = todoItem
                
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Todo Here..."
            textField = alertTextField
            
        }
        

        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
