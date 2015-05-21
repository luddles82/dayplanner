//
//  ViewController.swift
//  DayPlanner
//
//  Created by Nick Ludlow on 11/05/2015.
//  Copyright (c) 2015 Nick Ludlow. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext()
    
    @IBOutlet weak var todaysProgressLabel: UILabel!
    
    @IBOutlet weak var totalProgressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext!
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        
        var request = NSFetchRequest(entityName: "Tasks")
        request.returnsObjectsAsFaults = false
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        var results = context.executeFetchRequest(request, error: nil)
        let total = results?.count
        
        request.predicate = NSPredicate(format: "taskStatus = %@", "Complete")
        results = context.executeFetchRequest(request, error: nil)
        let totalComplete = results?.count
        
        request.predicate = NSPredicate(format: "taskDate = %@", "\(formatter.stringFromDate(today))")
        results = context.executeFetchRequest(request, error: nil)
        
        let todaysTotal = results?.count
        
        request.predicate = NSPredicate(format: "taskStatus = %@ && taskDate = %@", "Complete", "\(formatter.stringFromDate(today))")
        results = context.executeFetchRequest(request, error: nil)
        
        let todaysComplete = results?.count

        let todaysPercentage = todaysTotal! > 0 ?  Int(Float(todaysComplete!) / Float(todaysTotal!) * 100) : 0
        
        let totalPercentage = total! > 0 ? Int(Float(todaysComplete!) / Float(total!) * 100) : 0
        
        todaysProgressLabel.text = "\(todaysPercentage) %"
        totalProgressLabel.text = "\(totalPercentage) %"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

