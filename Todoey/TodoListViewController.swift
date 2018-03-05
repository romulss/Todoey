//
//  ViewController.swift
//  Todoey
//
//  Created by Roman on 04/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Joe", "Kill the dog", "Find out the meaning of life"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var taskName = UITextField ()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(taskName.text!)
            self.tableView.reloadData()
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Task name"
            taskName = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


}

