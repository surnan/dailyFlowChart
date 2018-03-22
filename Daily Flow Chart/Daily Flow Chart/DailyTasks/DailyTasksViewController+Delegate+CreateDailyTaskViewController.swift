//
//  DailyTasksViewController+Delegate+CreateDailyTaskViewController.swift
//  Daily Flow Chart
//
//  Created by admin on 3/18/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension DailyTasksViewController: CreateDailyTaskViewControllerDelegate {
    //MARK: delegate functions
    func addElementToTasks(task: Task){
        tasks.append(task)
        tableView.insertRows(at: [IndexPath.init(row: tasks.count-1, section: 0)] , with: .right)
    }
    
    func editExistingTask(task: Task) {
        guard let temp = tasks.index(of: task) else {print("Error trying to find editing element in tasks:"); return}
        let myIndexPath = IndexPath(row: temp, section: 0)
        tableView.reloadRows(at: [myIndexPath], with: .middle)
    }
}
