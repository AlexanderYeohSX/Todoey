//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kean Wei Wong on 22/12/2018.
//  Copyright © 2018 Kean Wei Wong. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController  {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.reloadData()
        tableView.separatorStyle = .none
        

    }
    
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        if let backgroundColor = categories?[indexPath.row].colour {
            cell.backgroundColor = UIColor(hexString: backgroundColor)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: backgroundColor)!, returnFlat: true)
        } else {
             cell.backgroundColor = UIColor(hexString: "1D9BF6")
        }
        
        
        return cell
        
    }

    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Save Categories failed \(error)")
        }
    }
    
    func loadCategories() {

       categories = realm.objects(Category.self)
    }

    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = (alert.textFields?[0].text)!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in

            textField.placeholder = "Enter a Category Here..."
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

      //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}
