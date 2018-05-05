//
//  CoreDataManager.swift
//  Daily Flow Chart
//
//  Created by admin on 3/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModelCoreData")  //left-pane-file-name
        container.loadPersistentStores(completionHandler: { (_, err) in
            if let err = err {
                fatalError("Unable to persistent container: \(err)")
            }
        })
        return container
    }()
    
    func fetchData() -> [Task] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        
        do {
            let taskArray = try context.fetch(fetchRequest)
            taskArray.forEach { print($0.name ?? "")}
            return taskArray
        } catch let fetchErr {
            fatalError("Fetch Request Error: \(fetchErr)")
        }
    }
}
