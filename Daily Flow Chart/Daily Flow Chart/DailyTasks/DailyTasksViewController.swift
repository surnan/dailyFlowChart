//
//  DailyTasksViewController.swift
//  Daily Flow Chart
//
//  Created by admin on 3/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class DailyTasksViewController: UITableViewController {
    
    let reuseID = "TaskTable"
    var tasks = [Task]()
    

    
    
    //MARK: Other functions
    @objc private func handleAdd(){
        print("Add pressed")
        let myCreateDailyTaskView = CreateDailyTaskViewController()
        myCreateDailyTaskView.delegate = self
        let navController = UINavigationController(rootViewController: myCreateDailyTaskView)
        present(navController, animated: true)
    }
    
    @objc private func handleReload(){
        print("Reload pressed")
        
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        //below works but let's try another method
        //                tasks.forEach { (task) in
        //                    context.delete(task)
        //                }
        
        //below also works
        //        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Task.fetchRequest())  //fetchRequest is NSObject method
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Task>(entityName: "Task") as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in tasks.enumerated() {
                let myIndexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(myIndexPath)
            }
            
            tasks.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .top)
        } catch let batchDeleteErr {
            print("Failed batchDelete on CoreData:", batchDeleteErr)
        }
        
        //below removes everything but there's no fancy, pretty animation
        //            tasks.removeAll()
        //            tableView.reloadData()
        
        //            tasks.forEach({ (task) in
        //                tasks.index(of: task)  <-- returns optional
        //            })
    }
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        tableView.register(DailyTaskListCell.self, forCellReuseIdentifier: reuseID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReload))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        
        navigationItem.title = "Daily Tasks"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let temp = try context.fetch(fetchRequest)
            temp.forEach({ (myTask) in
                print(myTask.name ?? "")
                self.tasks = temp
            })
        } catch let viewWillAppearErr {
            print("Unable to fetch in ViewDidAppear:", viewWillAppearErr)
        }
    }
}

