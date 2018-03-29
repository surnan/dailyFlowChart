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
    func editExistingTask(task:Task)
}


class CreateDailyTaskViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var taskImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Name: "
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.textAlignment = .center
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
    
    var currentTask: Task? {
        didSet {
            nameTextField.text = currentTask?.name
            
            if let date = currentTask?.date {
                eventTimePicker.date = date
            }
            
            if currentTask?.picture == nil {
                taskImageView.image = #imageLiteral(resourceName: "select_photo_empty")
            }
            //            taskImageView.image = currentTask?.picture as? UIImage
            
            if let cellImageData = currentTask?.picture{
                let imageData = UIImage(data: cellImageData)
                print("IMAGE CARRIED OVER")
                taskImageView.image = imageData
                
                ////////
                // Turn square avator into circular
                self.taskImageView.layer.cornerRadius = self.taskImageView.frame.width / 2
                self.taskImageView.clipsToBounds = true
                
                self.taskImageView.layer.borderColor = UIColor.black.cgColor
                self.taskImageView.layer.borderWidth = 2
            }
        }
    }
    
    @objc private func handleImageTap(){
        print("!!!!!!!Image has been tapped!!!!!!!")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self   //2 needed for getting feedback on which pic was tapped
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)   //2
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.taskImageView.image = editedImage

            ////////
            // Turn square avator into circular
            self.taskImageView.layer.cornerRadius = self.taskImageView.frame.width / 2
            self.taskImageView.clipsToBounds = true

            self.taskImageView.layer.borderColor = UIColor.black.cgColor
            self.taskImageView.layer.borderWidth = 2
            dismiss(animated: true, completion: nil)
            
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.taskImageView.image = image
            
            ////////
            // Turn square avator into circular
            self.taskImageView.layer.cornerRadius = self.taskImageView.frame.width / 2
            self.taskImageView.clipsToBounds = true
            
            self.taskImageView.layer.borderColor = UIColor.black.cgColor
            self.taskImageView.layer.borderWidth = 2
            
            
            dismiss(animated: true, completion: nil)
        }else{
            print("Something went wrong")
        }
    }
    
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave(){
        guard let name = nameTextField.text, !name.isEmpty else { print("Empty Name"); return}
        if currentTask == nil {
            savingNewTask()
        } else {
            editingTask()
        }
    }
    
    private func editingTask(){
        self.dismiss(animated: true ){
            let myContext = CoreDataManager.shared.persistentContainer.viewContext
            guard let myCurrentTask = self.currentTask else {print("Something Weird");return}
            myCurrentTask.name = self.nameTextField.text
            myCurrentTask.date = self.eventTimePicker.date
            
            guard let image = self.taskImageView.image else {return}
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            myCurrentTask.picture = imageData
            
            self.delegate?.editExistingTask(task: myCurrentTask)
            do {
                try myContext.save()
            } catch let handleSaveErr {
                print("Unable to save task:", handleSaveErr)
            }
        }
    }
    
    private func savingNewTask() {
        self.dismiss(animated: true ){
            let myContext = CoreDataManager.shared.persistentContainer.viewContext
            let myTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: myContext)
            myTask.setValue(self.nameTextField.text, forKey: "name")
            myTask.setValue(self.eventTimePicker.date, forKey: "date")
            
            
            guard let image = self.taskImageView.image else {return}
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            myTask.setValue(imageData, forKey: "picture")
            
            
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
        navigationItem.title = currentTask == nil ? "##Create New Task" : "Editing \(currentTask?.name ?? "")"
        
        [nameLabel, nameTextField, dateLabel, eventTimePicker, taskImageView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //
        taskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        taskImageView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 25).isActive = true
        //
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 25).isActive = true
        //
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25).isActive = true
        //
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25).isActive = true
        //
        eventTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventTimePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25).isActive = true
    }
}
