//
//  ViewController.swift
//  ios-todolist-propertylist
//
//  Created by omrobbie on 29/06/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit

struct Item: Encodable {

    let title: String
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("Items.plist")
    private var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
    }

    private func setupList() {
        title = "Todo List"
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func saveData(_ value: [Item]) {
        do {
            let data = try PropertyListEncoder().encode(value)
            try data.write(to: self.dataFilePath)
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    @IBAction func btnAddTapped(_ sender: Any) {
        var textField = UITextField()

        let alertVC = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (_) in
            self.items.append(Item(title: textField.text!))
            self.tableView.reloadData()
            self.saveData(self.items)
        }

        alertVC.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item..."
            textField = alertTextField
        }

        alertVC.addAction(actionCancel)
        alertVC.addAction(actionAdd)

        present(alertVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
}
