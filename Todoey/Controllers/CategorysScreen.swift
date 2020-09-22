//
//  CategorysScreen.swift
//  Todoey
//
//  Created by Thiện Đăng on 9/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategorysScreen: SwipeTableViewController {
    
    let realm = try! Realm()
    //    var categories = [CategoryData]()
    var categories : Results<CategoryRealm>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategory()
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var textFieldResult = UITextField()
        
        let alert = UIAlertController(title: "Please enter your category!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default, handler: {
            (action) in
            //code
            print("\(textFieldResult.text ?? "")")
            //            let newCategory = CategoryData(context: self.context)
            let newCategory = CategoryRealm()
            newCategory.name = textFieldResult.text!
            //            self.categories!.append(newCategory)
            self.saveCategory(category : newCategory)
        })
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "category name"
            textFieldResult = textField
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: {})
    }
    
    
    func saveCategory(category : CategoryRealm) {
        do {
            //            try context.save()
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("can't encode : \(error)");
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadCategory() {
        categories = realm.objects(CategoryRealm.self)
        //        do{
        //            categories = try context.fetch(request)
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        } catch{
        //            print(error)
        //        }
    }
    
    //tableCell DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcDestination = segue.destination as! ToDoListViewController
        if let indexPath = self.tableView.indexPathForSelectedRow{
            vcDestination.withCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name
        cell.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: CGRect(x: 0, y: 0, width: cell.bounds.width , height : cell.bounds.height ), andColors:[UIColor.randomFlat(),UIColor.flatBlue()])
        return cell
    }
    
    override func handleSwpipe(at indexPath: IndexPath) {
        super.handleSwpipe(at: indexPath)
        if let categoryForDelele = categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDelele)
                }
            } catch {
                print("error in deleting item : \(error)")
            }
        }
    }
}
