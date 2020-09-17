
import UIKit

class ToDoListViewController: UITableViewController {
    
    //    var myItem = ["Hello", "How are you ?" , "Good morning !"]
    var myItem = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("listItem.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath as Any)
        let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        print("library path is \(library_path)")
        //persist
        if let items = UserDefaults.standard.array(forKey: "listItem") as? [Item] {
            myItem = items
        }
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                myItem = try decoder.decode([Item].self, from: data)
            }catch {
                print("can't decoder");
            }
        }
    }
    
    //    Add Item
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textFieldResult = UITextField()
        
        let alert = UIAlertController(title: "Please enter your item!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default, handler: {
            (action) in
            //code
            print("\(textFieldResult.text ?? "")")
            self.myItem.append(Item(title: textFieldResult.text!, status: false))
            
            print("\(self.myItem)")
            
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.myItem)
                try data.write(to : self.dataFilePath!)
            }catch {
                print("can't encode")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        return myItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoList", for: indexPath)
        let item = myItem[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.status == true ? .checkmark :.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = myItem[indexPath.row]
        myItem[indexPath.row].status = !(item.status!)
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

