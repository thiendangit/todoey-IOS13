
import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //    var myItem = ["Hello", "How are you ?" , "Good morning !"]
    //    var myItem = [Item]()
    var myItem : Results<ItemRealm>?
    let realm = try! Realm()
    
    //    var withCategory : CategoryData?
    var withCategory : CategoryRealm?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("listItem.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath as Any)
        let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        print("library path is \(library_path)")
        //persist
        searchBar.delegate = self
        //        if let items = UserDefaults.standard.array(forKey: "listItem") as? [Item] {
        //            myItem = items
        //        }
        loadItem(predicate: nil)
        print("category \(withCategory?.name ?? "data")")
    }
    
    //    Add Item
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textFieldResult = UITextField()
        
        let alert = UIAlertController(title: "Please enter your item!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default, handler: {
            (action) in
            //code
            print("\(textFieldResult.text ?? "")")
            //            let newItem = Item()
            //            newItem.title = textFieldResult.text!
            //            newItem.status = false
            //            newItem.parentCategory = self.withCategory
            //            self.myItem.append(newItem)
            //            self.saveItem()
            if let selectedItem = self.withCategory {
                do {
                    try self.realm.write{
                        let newItem = ItemRealm()
                        newItem.title = textFieldResult.text!
                        newItem.status = false
                        selectedItem.items.append(newItem)
                        self.tableView.reloadData()
                    }
                }catch {
                    print("can't save Data, \(error)")
                }
            }
        })
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Some item name"
            textFieldResult = textField
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: {})
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoList", for: indexPath)
        if let item = myItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.status == true ? .checkmark :.none
        }else{
            cell.textLabel?.text = "no check"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = myItem?[indexPath.row]{
            do {
                try realm.write{
                    item.status = !item.status
                    tableView.reloadData()
                }
            } catch {
                print("can't change status \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //        let item = myItem?[indexPath.row]
        //        myItem?[indexPath.row].status = !(item!.status)
        //        DispatchQueue.main.async {
        //            tableView.reloadData()
        //        }
    }
    
    func saveItem(item : ItemRealm) {
        do {
            try context.save()
        } catch {
            print("can't encode : \(error)");
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        myItem = withCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //        //predicate by category Core Data
        //        let predicateByCategory = NSPredicate(format: "parentCategory.name MATCHES %@", withCategory!.name!)
        //        //predicate by input
        //        if let combinePredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateByCategory, combinePredicate])
        //        }else{
        //            request.predicate = predicateByCategory
        //        }
        //        do{
        //            myItem = try context.fetch(request)
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        } catch {
        //            print("can't decoder : \(error)");
        //        }
    }
}

extension ToDoListViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        print(searchBar.text ?? "")
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //        loadItem(with : request, predicate: predicate)
        myItem = withCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        if searchText.count == 0 {
            myItem = withCategory?.items.sorted(byKeyPath: "title", ascending: true)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }else{
            myItem = withCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
        
    }
}

