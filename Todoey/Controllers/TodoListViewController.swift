//
//  ViewController.swift
//  Todoey
//
//  Created by Kean Wei Wong on 18/12/2018.
//  Copyright © 2018 Kean Wei Wong. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory: Category? {
    
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        tableView.separatorStyle = .none
        
        print(dataFilePath)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else {
            fatalError()
        }
        
        updateNavBar(withHexCode: colourHex)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar()
    }
    
    //MARK: - Nav Bar Setup Method
    func updateNavBar(withHexCode colourHexCode: String = "1D9BF6" ) {
        
        navigationController?.navigationBar.barTintColor = UIColor(hexString:colourHexCode)
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString:(selectedCategory?.colour)!)!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString:(selectedCategory?.colour)!)!, returnFlat: true )]
        
        searchBar.barTintColor =  UIColor(hexString:(selectedCategory?.colour)!)!
    }
    
    // MARK - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString:(selectedCategory?.colour)!)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(items!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = items?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
           
        }
        
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
                if let currentCategory = self.selectedCategory {
                   
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = todoItem
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print(error)
                    }

                }

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
    
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
                
            } catch {
                print(error)
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }

        } else {
            items = items?.filter( "title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
        }
        
        tableView.reloadData()
    }
}
