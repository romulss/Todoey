//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roman on 09/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var realm: Realm!
    
    
    var categoriesArray: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        realm = try! Realm()
        super.viewDidLoad()
        loadCategories()
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Caregories Created"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
            
            
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var categoryName = UITextField()
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = categoryName.text!
            self.save(category: newCategory)
            
        }
        alert.addTextField { (textField) in
            categoryName = textField
            categoryName.placeholder = "Add"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        }catch {
            
        }
        tableView.reloadData()
    }
    func loadCategories () {
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
