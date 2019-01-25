//
//  ViewController.swift
//  MVVM Test
//
//  Created by 范国徽 on 2019/1/24.
//  Copyright © 2019年 范国徽. All rights reserved.
//

import UIKit
let cellIdentifier = "cellIdentifier";
class ViewController: UITableViewController {

    let store = ToDoItemStore.share

    @IBAction func addAction(_ sender: Any) {
        let count = store.maxIndex
        store.append(index: ToDoItem.init(id: count))
    }

    @IBOutlet weak var addButton: UIBarButtonItem!

    @objc func toItemChange(notification: Notification) {
        let userinfo = notification.userInfo
        let behavior = userinfo![Notification.Name.didChangeItemsNotification] as! ToDoItemStore.ToDoItemProviderBehavior
        switch behavior {
        case .add(let todoItemList):
            let addListPath = todoItemList.map { IndexPath.init(row: $0, section: 0)}
            print(addListPath)
            if addListPath.isEmpty {
                return
            }
            self.tableView.insertRows(at: addListPath, with: .none)
        case .remove(let todoItemList):
            let deleteListPath = todoItemList.map { IndexPath.init(row: $0, section: 0)}
            print(deleteListPath)
            self.tableView.deleteRows(at: deleteListPath, with: .automatic)
        case .reload:
            self.tableView.reloadData()
            break
        }
        self.addButton.isEnabled = store.count < 10
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(toItemChange(notification:)), name: .didChangeItemsNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

}
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = store.itemOfIndex(index: indexPath.row)!.title
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextualAction = UIContextualAction.init(style: .destructive, title: "Delete") { (_, _, done) in
            self.store.removeIndex(of: indexPath.row)
            done(true)
        }
        let swipConfig = UISwipeActionsConfiguration.init(actions: [deleteContextualAction])

        return swipConfig
    }
}

