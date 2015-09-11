//
//  RuleTableViewController.swift
//  Ghost
//
//  Created by TovaM on 9/8/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class RuleTableViewController: UIViewController {
   
    var rules: [String] = ["1. Each player inputs one letter on their turn","2. The letter must have potential to spell a word  after it is added to the prior letters, but does not spell one itself!","3. You can challenge the player before you if you believe the letter they added cannot spell a word","4. You have 5 lives before 'GHOST' is spelled and you lose the game","5. Every round that someone loses, they get a letter added to their score above, and the word resets","6. If you spell a word equal to the minimum word size then you lose the round automatically"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromRGB(0x848484)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rules.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rule", forIndexPath: indexPath) as! RuleViewCell
        cell.RuleLabel.numberOfLines = 0
        cell.RuleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.RuleLabel.text = rules[indexPath.row]
        cell.RuleLabel.textColor = UIColor.whiteColor()
        cell.RuleLabel.sizeToFit()
        
        cell.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
       
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
