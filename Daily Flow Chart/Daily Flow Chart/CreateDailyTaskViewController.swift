//
//  CreateDailyTaskViewController.swift
//  Daily Flow Chart
//
//  Created by admin on 3/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

protocol CreateDailyTaskViewControllerDelegate {
    func addElementToTasks(task: Task)
}


class CreateDailyTaskViewController: UIViewController {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Name: "
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        return textField
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Time: "
        return label
    }()
    
    let eventTimePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    
    var delegate: CreateDailyTaskViewControllerDelegate?
    var currentTask: Task?
    
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave(){
        guard let name = nameTextField.text, !name.isEmpty else { print("Empty Name"); return}
        
        self.dismiss(animated: true ){
            let myContext = CoreDataManager.shared.persistentContainer.viewContext
            let myTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: myContext)
            myTask.setValue(self.nameTextField.text, forKey: "name")
            self.delegate?.addElementToTasks(task: myTask as! Task)
            
            do {
                try myContext.save()
            } catch let handleSaveErr {
                print("Unable to save task:", handleSaveErr)
            }
        }
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        navigationItem.title = "Create Task"
        
        [nameLabel, nameTextField, dateLabel, eventTimePicker].forEach {view.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false}
        
        //
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 75).isActive = true
        //
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 75).isActive = true
        //
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 75).isActive = true
        //
        eventTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventTimePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 75).isActive = true
    }
    
}
