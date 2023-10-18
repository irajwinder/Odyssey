//
//  UserListViewController.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/17/23.
//

import UIKit
import CoreData

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var users: [User] = [] // Store the fetched users
    
    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "UserList"
        
        fetchUsers()
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }

    // Fetch users from Core Data
    func fetchUsers() {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //fetch the users based on the fetch request
            self.users = try managedContext.fetch(User.fetchRequest())
            self.usersTableView.reloadData()
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Delete user from Core Data
    func deleteUser(at indexPath: IndexPath) {
        // Get a reference to the AppDelegate by accessing the shared instance of UIApplication
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Access the managed object context from the AppDelegate's persistent container.
        let managedContext = appDelegate.persistentContainer.viewContext
        // Delete the user at the specified indexPath from the managed context.
        managedContext.delete(users[indexPath.row])

        do {
            //save the changes made to the managed context.
            try managedContext.save()
            print("User deleted successfully.")
        } catch let error as NSError {
            // Handle the error
            print("Could not delete. \(error), \(error.userInfo)")
        }
        fetchUsers()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count // Return the count of fetched users
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let user = users[indexPath.row]
        if let userName = user.value(forKeyPath: "userName") as? String {
            cell.userName.text = userName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteUser(at: indexPath)
        }
    }
}
