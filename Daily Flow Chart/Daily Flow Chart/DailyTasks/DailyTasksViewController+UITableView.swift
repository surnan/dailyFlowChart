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
        cell.backgroundColor = UIColor.lightBlue
        
        
//        var date : nsd
        
        var cellTextLabel = ""
        if let cellName = tasks[indexPath.row].name{
            cellTextLabel = "\(cellName)"
        }
        
        var cellTextLabel2 = ""
        if let cellDate = tasks[indexPath.row].date {
            let myDateFormater = DateFormatter()
            myDateFormater.dateFormat = "hh:mm a"
            cellTextLabel2 = myDateFormater.string(from: cellDate)
        } else {
            cellTextLabel2 = "NONE SAVED"
        }

        cell.textLabel?.text = "\(cellTextLabel) ... \(cellTextLabel2)"
        
        if let cellImageData = tasks[indexPath.row].picture {
        let imageData = UIImage(data: cellImageData)
        cell.imageView?.image = imageData
        
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please Create a Task...."
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  tasks.count != 0 ?  0:100
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
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.green
        return [deleteAction, editAction]
    }
    
    //this function header exactly matches the closure parameters of 'deleteAction'
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath){
        let myCreateDailyTaskViewController = CreateDailyTaskViewController()
        myCreateDailyTaskViewController.currentTask = tasks[indexPath.row]
        myCreateDailyTaskViewController.delegate = self
        let myNavController = UINavigationController(rootViewController: myCreateDailyTaskViewController)
        present(myNavController, animated: true, completion: nil)
    }
}
