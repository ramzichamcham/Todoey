//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //setup standard UserDefaults for persistent data storage.
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "to do 1"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "to do 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "to do 3"
        itemArray.append(newItem3)

        
        //Load Elements from UserDefaults inside viewDidLoad.
//        if let items = defaults.array(forKey: K.defaultsArray) as? [String]{
//            itemArray = items
//        }
    }
    
    //MARK: - TableView DataSource Methods.
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableIdentifier, for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel!.text = item.title
        
        //Ternary operator => value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none





        
        return cell
    }
    
    //MARK: - TableView Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //to remove highlight from cell
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the Add Item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: K.defaultsArray)
            self.tableView.reloadData()
            
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
    }
    
    
}


