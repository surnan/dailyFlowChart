//
//  DailyTasksViewController+UITableView.swift
//  Daily Flow Chart
//
//  Created by admin on 3/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

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
            let company = self.tasks[indexPath.row]
            print("Deletion Action chosen", company)
            
            //reverse order of the next two lines and it crashes with '***Assertion Failure'
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //reverse order of the above two lines and it crashes with '***Assertion Failure'

            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let deleteError {
                print("Unable to delete from row from Store", deleteError)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            print("Edit Action chosen")
        }
        editAction.backgroundColor = UIColor.green
        return [deleteAction, editAction]
    }
}
