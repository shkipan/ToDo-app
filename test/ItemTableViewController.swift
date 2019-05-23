//
//  ItemTableViewController.swift
//  test
//
//  Created by Dmytro SKRYPNYK on 5/23/19.
//  Copyright © 2019 Dmytro SKRYPNYK. All rights reserved.
//

import UIKit
import Foundation

class ItemTableViewController: UITableViewController, UISearchBarDelegate {

    let maxItemLength = 100
    var items = [Item]()
    
    func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedItems = loadItems() {
            items += savedItems
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell

        let item = items[indexPath.row]
        var resName = item.name
        if (resName.count > maxItemLength) {
            let index = resName.index(resName.startIndex, offsetBy: maxItemLength)
            resName = String(resName[..<index]) + "..."
        }
        cell.nameLabel.text = resName
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy\nhh-mm"
        let dataString = formater.string(from: item.date)
        cell.dataLabel.text = dataString
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveItems()
        }

        
        let shareButton = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            // share item at indexPath
                let selectedItem = self.items[indexPath.row]
                let activityVC = UIActivityViewController(
                    activityItems: [selectedItem.name],
                    applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
        }
            
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "EditNote", sender: tableView.cellForRow(at: indexPath))
        }
        
        deleteButton.backgroundColor = #colorLiteral(red: 1, green: 0.1900274754, blue: 0, alpha: 1)
        shareButton.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        editButton.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        return [deleteButton, shareButton, editButton]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowDetails") || (segue.identifier == "EditNote") {
            let detailedVC = segue.destination as! ViewController
            if let selectedCell = sender as? ItemTableViewCell {
                let index = tableView.indexPath(for: selectedCell)!
                let selectedItem = items[index.row]
                detailedVC.item = selectedItem
                detailedVC.index = index
                detailedVC.isEditable = (segue.identifier == "EditNote")
            }
        }
        else if segue.identifier == "AddItem" {
        }
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        let srcViewCon = sender.source as? ViewController
        let item = srcViewCon?.item
        if  (srcViewCon != nil && item?.name != "") {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                
                // Update existing item
                items[selectedIndex.row] = item!
                tableView.reloadRows(at: [selectedIndex], with: .none)
            }
            else if let selectedIndex = srcViewCon?.index {
                items[selectedIndex.row] = item!
                tableView.reloadRows(at: [selectedIndex], with: .none)
            }
            else {
                // Add a new item
                    let newIndexPath = IndexPath(row: items.count, section: 0)
                    items.append(item!)
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            saveItems()
        }
    }
    
    func saveItems() {
        let isSaved = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if !isSaved {
            print("Failed to save items...")
        }
    }
}
