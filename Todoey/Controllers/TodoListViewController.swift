//
//  ViewController.swift
//  Todoey
//
//  Created by Roman on 04/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var realm = try! Realm ()
    var todoItems: Results<Item>?
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
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType =  (item.done) ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items created"
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    }
                }
                catch {
                    
                }
            }
            
           // self.save(item: item)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var taskName = UITextField ()
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                let newItem = Item()
                newItem.title = taskName.text!
                newItem.dateCreated = Date()
                self.save(item: newItem,parentCategory: currentCategory)
            }
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Task name"
            taskName = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(item: Item, parentCategory: Category) {
       
        do{
            try realm.write {
                realm.add(item.self)
                parentCategory.items.append(item)
            }
        } catch {
            
        }
         self.tableView.reloadData()
    }
    func loadItems () {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        let sort = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sort]
//        loadItems(with:  request, predicate: predicate)


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

