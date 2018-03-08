//
//  DailyTasksViewController+UITableView.swift
//  Daily Flow Chart
//
//  Created by admin on 3/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension DailyTasksViewController {
    
    //MARK: uitableview functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            print("Deletion Action chosen")
        }
        
        let editAction = UITableViewRowAction(style: .destructive, title: "Edit") { (rowAction, indexPath) in
            print("Edit Action chosen")
        }
        
        return [deleteAction, editAction]
    }
    
}
