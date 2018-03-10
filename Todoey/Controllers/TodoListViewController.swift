//
//  ViewController.swift
//  Todoey
//
//  Created by Roman on 04/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    // let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var taskName = UITextField ()
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = taskName.text!
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            
//            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
           
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Task name"
            taskName = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
       
        do{
            try context.save()
        } catch {
            
        }
         self.tableView.reloadData()
    }
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",  selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
           itemArray = try context.fetch(request)
        } catch {
            
        }
        tableView.reloadData()
        

    }
    

}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sort]
        loadItems(with:  request, predicate: predicate)
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        else{
            searchBarSearchButtonClicked(searchBar)
        }
    }

    
}
