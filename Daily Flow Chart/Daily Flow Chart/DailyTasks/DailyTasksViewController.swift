//
//  DailyTasksViewController.swift
//  Daily Flow Chart
//
//  Created by admin on 3/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class DailyTasksViewController: UITableViewController, CreateDailyTaskViewControllerDelegate {
  
    let reuseID = "TaskTable"
    var tasks = [Task]()
    
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
    }
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(handleReload))
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

