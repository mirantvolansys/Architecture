//
//  UserListViewController.swift
//  MVC_Architecture
//
//  Created by Nirav Hathi on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    // used if web service already get call and user reach at last record
    var isWebServiceGetCalled: Bool = false
    
    //webservice allready called for current index page
    var currentIndexPage = 1
    
    //tableview
    @IBOutlet weak var tableView: UITableView!
    
    //model object for user list
    var users: User?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getusers()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //webservice
    func getusers(page: Int = 1) {
        let param: [String: Any] = ["page": page]
        self.isWebServiceGetCalled = true
        API.getRequest(relPath: "users", param: param) { (json, statusCode) in
            if statusCode == 200, let resObj = json as? NSDictionary {
                //check user list already exists
                if self.users != nil {
                    let users = User(fromDictionary: resObj as! [String: Any])
                    self.users?.data.append(contentsOf: users.data)
                    self.tableView.reloadData()
                    self.isWebServiceGetCalled = false
                    return
                }
                
                //init model object
                self.users = User(fromDictionary: resObj as! [String: Any])
                
                //reload tableview data
                self.tableView.reloadData()
                
                self.isWebServiceGetCalled = false
            } else if let errObj = json {
                print(errObj)
                self.isWebServiceGetCalled = false
            }
        }
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
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //custom cell init
        let iCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        
        //set image user
        iCell.imageUser.download(imageFromURL: URL(string: users?.data[indexPath.row].avatar ?? "")!, contentMode: .scaleToFill, placeHolderImage: UIImage()) { (image) in
            iCell.imageUser.image = image
        }
        
        //user name
        let stringFirstName = users?.data[indexPath.row].firstName ?? ""
        let stringLastName = users?.data[indexPath.row].lastName ?? ""
        iCell.labelName.text = stringFirstName + " " + stringLastName
        
        //user email
        iCell.labelEmail.text = users?.data[indexPath.row].email ?? ""
        return iCell
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //check reach at end of tableview
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        //call webservice if reach at end and number of page > 4
        if(isReachingEnd && self.isWebServiceGetCalled == false && currentIndexPage < 4) {
            self.currentIndexPage = currentIndexPage + 1
            self.getusers(page: self.currentIndexPage)
        }
    }
}
