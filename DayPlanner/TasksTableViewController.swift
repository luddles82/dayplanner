//
//  TasksTableViewController.swift
//  DayPlanner
//
//  Created by Nick Ludlow on 12/05/2015.
//  Copyright (c) 2015 Nick Ludlow. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func backPressed(sender: AnyObject) {
    self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! EditTaskViewController
        
        if segue.identifier == "editTask"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
            
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                
                controller.taskItem = object
                controller.newTask = false
            
            }
            
        }else if segue.identifier == "newTask" {
            
            controller.newTask = true
        
        }
    }
    
    
    // MARK: - Table View Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var noofSections: Int? = self.fetchedResultsController.sections?.count
        if noofSections! == 0 {
            noofSections = 1
        }
        return noofSections!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.fetchedResultsController.sections!.count > 0 {
        
        let SectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
            return SectionInfo.name!
        }else{
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.fetchedResultsController.sections!.count > 0 {
        
        let SectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
            return SectionInfo.numberOfObjects
        }else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        
            let context = self.fetchedResultsController.managedObjectContext
        
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.textLabel!.text = object.valueForKey("taskDescription")!.description
        let taskStatus = object.valueForKey("taskStatus")!.description
        let taskDate = object.valueForKey("taskDate")!.description
        
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 12.0)
        cell.detailTextLabel?.text = "\(taskStatus) (\(taskDate))"
    
    }
    
    
    // MARK: - Fetched Results Controller
    
    var fetchedResultsController: NSFetchedResultsController {
    
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "taskDateStamp", ascending: false)
        //let sortDescriptors [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let afetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "taskDate", cacheName: nil)
        afetchedResultsController.delegate = self
        _fetchedResultsController = afetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error){
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index:sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            //self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            println("Update method to be written")
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            return
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    

}
