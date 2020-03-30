//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //where the data is being stored for our current app
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //to remove highlight from cell
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
    }
    
    //MARK: - Model manipulation methods
    func saveItems(){
        //Encode a new Item to Items.plist
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){

//        let request: NSFetchRequest = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK: - UISearchBar Delegate methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
                
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
}


