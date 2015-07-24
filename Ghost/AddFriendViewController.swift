//
//  AddFriendViewController.swift
//  Ghost
//
//  Created by TovaM on 7/21/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
//import Parse

class AddFriendViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    //use fb api to get list of friends,
    
    var users: [PFUser]?
    var lastSelectedIndexPath :NSIndexPath?

     let ParsePlayedWithClass       = "PlayedWith"
     let ParsePlayedWithFromUser    = "fromUser"
     let ParsePlayedWithToUser      = "toUser"
    
    var playedWithUsers: [PFUser]? = []{
        didSet {
            /**
            the list of following users may be fetched after the tableView has displayed
            cells. In this case, we reload the data to reflect "following" status
            */
            tableView.reloadData()
        }
    }
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    // this view can be in two different states
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                query = allUsers(updateList)
                //                query = getPlayedWithUsersForUser(PFUser.currentUser()!, completionBlock:updateList)
              
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                query = searchUsers(searchText, completionBlock:updateList)
            }
        }
    }
    
    // MARK: Update userlist
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
     func allUsers(completionBlock:PFArrayResultBlock) -> PFQuery {
        let query = PlayerP.query()!
        // exclude the current user
        query.whereKey("username",
            notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending("username")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    /**
    Fetch users whose usernames match the provided search term.
    
    :param: searchText The text that should be used to search for users
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
     func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
        -> PFQuery {
            /*
            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
            Regex can be slow on large datasets. For large amount of data it's better to store
            lowercased username in a separate column and perform a regular string compare.
            */
            let query = PFUser.query()!.whereKey("username",
                matchesRegex: searchText, modifiers: "i")
            
            query.whereKey("username",
                notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending("username")
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }

    func updateList(results: [AnyObject]?, error: NSError?) {
        self.users = results as? [PFUser] ?? []
        self.tableView.reloadData()
        
        if let error = error {
            println("error")
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func getPlayedWithUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) -> PFQuery{
        let query = PFQuery(className: ParsePlayedWithClass) //getting all the relationships
        
        query.whereKey(ParsePlayedWithFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    
    @IBAction func SaveButton(sender: AnyObject) {
        PFUser.currentUser()!["playedWith"] = playedWithUsers
        PFUser.currentUser()!.saveInBackgroundWithBlock { (Success, error) -> Void in
        if let error = error {
                println("Found an error: \(error)")
            }
            if Success {
                self.dismissViewControllerAnimated(true, completion: nil)
                println("success")
            }
        }
       // self.performSegueWithIdentifier("Save", sender: self)
        
    }
  
    /**
    Establishes a follow relationship between two users.
    
    :param: user    The player that is playing 
    :param: toUser  The player that played with him
    */
     func addPlayedWithRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let PlayedWithObject = PFObject(className: ParsePlayedWithClass) //setting new relationships
        PlayedWithObject.setObject(user, forKey: ParsePlayedWithFromUser)
        PlayedWithObject.setObject(toUser, forKey: ParsePlayedWithToUser)
        
        PlayedWithObject.saveInBackgroundWithBlock(nil)
    }
     func removePlayedWithRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParsePlayedWithClass)
        query.whereKey(ParsePlayedWithFromUser, equalTo:user)
        query.whereKey(ParsePlayedWithToUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                println("error")
                return
            }
            
            
            let results = results as? [PFObject] ?? []
            
            for hits in results {
                hits.deleteInBackgroundWithBlock(nil)
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

 }
}
// MARK: TableView Data Source

extension AddFriendViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! AddFriendTableViewCell
        
        let user = users![indexPath.row]
        cell.user = user
        cell.delegate = self
        
        return cell
    }
}
// MARK: Searchbar Delegate

extension AddFriendViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers(searchText, completionBlock:updateList)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let newCell = tableView.cellForRowAtIndexPath(indexPath)  as! AddFriendTableViewCell

        
        if  newCell.accessoryType == .Checkmark {
            newCell.accessoryType = .None
            
        }
        else {
            newCell.accessoryType = .Checkmark
            playedWithUsers?.append(newCell.user!)

            lastSelectedIndexPath = indexPath

            
        
        }
    }

    
}

// MARK: FriendSearchTableViewCell Delegate

extension AddFriendViewController: AddFriendTableViewCellDelegate {
    
    func cell(cell: AddFriendTableViewCell,  didSelectUserToPlay user: PFUser) {
        
        addPlayedWithRelationshipFromUser(PFUser.currentUser()!, toUser: user)
        // update local cache
        cell.selected = true
    }
    func cell(cell: AddFriendTableViewCell,  didUnSelectUserToPlay user: PFUser) {
        
        if var playedWithUsers = playedWithUsers {
            removePlayedWithRelationshipFromUser(PFUser.currentUser()!, toUser: user)
            // update local cache
            removeObject(user, fromArray: &playedWithUsers)
        }
    }
     func removeObject<T : Equatable>(object: T, inout fromArray array: [T])
    {
        var index = find(array, object)
        if let index = index {
            array.removeAtIndex(index)
        }
    }

}

