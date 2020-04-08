//  CategoryViewController.swift
//  Todoey
//
//  Created by Ramzi chamcham on 2020-03-31.
//  Copyright © 2020 App Brewery. All rights reserved.


import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //Access point to our Realm Database.
    let realm = try! Realm()
    
    var categories: Results<Category>?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load data into tableView
        loadCategories()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Categories array.count
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // needs reuseable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellReuseID, for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    //MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.toItemsSegueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation methods
    //saveData()
    func save(_ category: Category){
        do{
            try realm.write{
                realm.add(category)
                }
        }catch{
            print("Error saving context")
        }
        tableView.reloadData()
    }
    
//    loadData()
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //AlertController
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Category"
        }
        alert.addAction(action)
        present(alert, animated: true)
    
    }
    
    
    
}
