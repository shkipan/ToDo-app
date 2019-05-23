//
//  ViewController.swift
//  test
//
//  Created by Dmytro SKRYPNYK on 5/22/19.
//  Copyright © 2019 Dmytro SKRYPNYK. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var item: Item?
    var index: IndexPath?
    var isEditable: Bool = true;
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var newItemTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item {
            newItemTextView.text = (item.name as NSString) as String!
            newItemTextView.isEditable = isEditable
            saveButton.isEnabled = isEditable
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
            let name = newItemTextView.text ?? ""
            item = Item(name: name)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

