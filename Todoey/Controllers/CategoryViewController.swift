//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roman on 09/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = categoriesArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
            
            
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var categoryName = UITextField()
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName.text
            self.categoriesArray.append(newCategory)
            self.saveCategories()
            
        }
        alert.addTextField { (textField) in
            categoryName = textField
            categoryName.placeholder = "Add"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveCategories () {
        do {
            try context.save()
        }catch {
            
        }
        tableView.reloadData()
    }
    func loadCategories (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categoriesArray = context.fetch(request)
        } catch {
            print ("Error fetching: \(request)")
        }
        tableView.reloadData()
    }
    
}
