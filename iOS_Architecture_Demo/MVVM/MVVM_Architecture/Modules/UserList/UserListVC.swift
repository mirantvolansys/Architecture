//
//  UserListVC.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 31/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserListVC: UIViewController {

    let userListVM = UserListViewModel()
    var isLoadingNewContent: Bool = false
    
    //For Pagination
    var isDataLoading: Bool = false
    var pageIndex: Int = 1

    @IBOutlet weak var tblUsersList: UITableView!
    
    /// View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getUserList(forPage: pageIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Setup UI
    fileprivate func setupUI() {
        //dynamic TableView cell Height
        self.tblUsersList.estimatedRowHeight = 80.0
        self.tblUsersList.rowHeight = UITableView.automaticDimension
    }
    
    fileprivate func getUserList(forPage pageNumber: Int) {
        SVProgressHUD.show()

        userListVM.getUsersList(forPage: pageNumber, success: { (_) in
            self.tblUsersList.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            printError(logMessage: error.localizedDescription)
            print("Error Retrieving users :\(error.localizedDescription)")
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func logout_Tapped(_ sender: Any) {
        let okAction = UIAlertAction(title: "Logout", style: .default) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
    
        showAlertView(withTitle: "Alert", message: "Are you sure you want to logout ?", withActions: [okAction, cancelAction], dismissOnOutisideTouch: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UserListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListVM.aryUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCellID") as! UserListCell
        
        let userObj = userListVM.aryUsers[indexPath.row]
        cell.configureCell(forUser: userObj)
        
        return cell
    }
}

extension UserListVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tblUsersList.contentOffset.y + tblUsersList.frame.size.height) >= tblUsersList.contentSize.height {
            if !isDataLoading {
                isDataLoading = true
                self.pageIndex += 1
                
                self.getUserList(forPage: self.pageIndex)
            }
        }
    }
}
