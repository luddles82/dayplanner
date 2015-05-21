//
//  EditTaskViewController.swift
//  DayPlanner
//
//  Created by Nick Ludlow on 12/05/2015.
//  Copyright (c) 2015 Nick Ludlow. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext()
    
    var newTask: Bool = true
    var taskItem: AnyObject? = nil
    
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    
    @IBOutlet weak var saveButton: UIButton!

    @IBAction func backPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let task: AnyObject = self.taskItem {
            
            taskTextField.text = task.valueForKey("taskDescription")!.description
            if task.valueForKey("taskStatus")!.description == "Compelete" {
                statusSwitch.on = true
                taskStatusLabel.text = "Complete"
            } else {
                statusSwitch.on = false
                taskStatusLabel.text = "Open"
            }
            
            
        }
    }
    
    
    @IBAction func statusSwitchChanged(sender: UISwitch) {
        
        if sender.on {
            
            taskStatusLabel.text = "Complete"
            
        }else{
            
            taskStatusLabel.text = "Open"
        }
        
    }
    
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if taskTextField.text == "" {
        
            var alert = UIAlertController(title: "Error", message: "Provide a task to save", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }else{
        
            if saveButton.titleLabel?.text == "Save" {
            
            let today = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
                
            var newTask = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: context) as! NSManagedObject
                
            newTask.setValue(formatter.stringFromDate(today), forKey: "taskDate")
            newTask.setValue(taskTextField.text, forKey: "taskDescription")
            newTask.setValue(taskStatusLabel.text, forKey: "taskStatus")
            newTask.setValue(today, forKey: "taskDateStamp ")
                
                var error: NSError? = nil
                if !context.save(&error) {
                    
                abort()
                    
                } else {
                    
                    println("Record Saved")
                }
                
                self.performSegueWithIdentifier("goToTasks", sender: self)
            } else {
                
                if let task: AnyObject = self.taskItem {
                
                    task.setValue(taskTextField.text, forKey: "taskDescription")
                    task.setValue(taskStatusLabel.text, forKey: "taskStatus")
                
                    var error: NSError? = nil
                    if !context.save(&error){
                        abort()
                    }else {
                        println("Record Updated")
                    }
                    self.performSegueWithIdentifier("goToTasks", sender: self)
                
                    }
        
                }
        
        
    }
    
    
           func viewDidLoad() {
        super.viewDidLoad()
        
        if newTask == true{
        saveButton.setTitle("Save", forState: .Normal)
        }else{
        saveButton.setTitle("Update", forState: .Normal)
        }
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext!
        
        taskTextField.delegate = self
        
        }
        
        func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
            
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            return true
          
        }
    }

}
