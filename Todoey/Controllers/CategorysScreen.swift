//
//  CategorysScreen.swift
//  Todoey
//
//  Created by Thiện Đăng on 9/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategorysScreen: UITableViewController  {
    
    var categories = [CategoryData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var textFieldResult = UITextField()
        
        let alert = UIAlertController(title: "Please enter your category!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default, handler: {
            (action) in
            //code
            print("\(textFieldResult.text ?? "")")
            let newCategory = CategoryData(context: self.context)
            newCategory.name = textFieldResult.text!
            self.categories.append(newCategory)
            self.saveCategory()
        })
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "category name"
            textFieldResult = textField
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: {})
    }
    
    
    func saveCategory() {
        do {
            try context.save()
        }catch {
            print("can't encode : \(error)");
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadCategory(with request : NSFetchRequest<CategoryData> = CategoryData.fetchRequest()) {
        do{
            categories = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch{
            print(error)
        }
    }
    
    //tableCell DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcDestination = segue.destination as! ToDoListViewController
        if let indexPath = self.tableView.indexPathForSelectedRow{
            vcDestination.withCategory = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreen" , for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}
