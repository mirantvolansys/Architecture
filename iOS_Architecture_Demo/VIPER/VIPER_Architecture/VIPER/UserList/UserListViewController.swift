//
//  UserListViewController.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit

protocol UserListProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
    func updateUserList(userData : UserListEntity?, errorString : String?)
}

class UserListViewController: UIViewController, UserListProtocol {
    //var interactor : UserListInteractorProtocol?
    var presenter : UserListPresentationProtocol?
    
    // MARK: IBOutlets
    @IBOutlet weak var userListTableview: UITableView!
    
    var userListData : UserListEntity?
    var loginData : LoginEntity?
    var signUpData : SignUpEntity?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = UserListInteractor()
        let presenter = UserListPresenter()
        let router = UserListRouter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableview.tableFooterView = UIView()
        self.presenter?.callUserListRequest()
        
        print("Login Data := \(String(describing: loginData?.dictionaryRepresentation()))")
        print("Signup Data :- \(String(describing: signUpData?.dictionaryRepresentation()))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated:false)
    }
    
    //MARK: functions
    /**
     User can display alert
     Parameters : -
        strTitle -> Pass title of alert
        strMessage -> Pass message of alert
     */
    func displayAlert(strTitle : String, strMessage : String) {
        //nameTextField.text = viewModel.name
        self.showAlertView(withTitle: strMessage, message: strMessage)
    }
    
    /**
     User can get list of user by this delegate method which we get from api and sent by presenter
     Parameters : -
        userData -> Dictionary of user list response parameters
        errorString -> error string if any error in user list reponse
     */
    func updateUserList(userData : UserListEntity?, errorString : String?) {
        if(errorString == nil) {
            userListData = userData
            userListTableview.reloadData()
        } else {
            self.displayAlert(strTitle: "Error", strMessage: errorString!)
        }
    }
}

//MARK: Tableview delegate & datasource methods
extension UserListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellUserList") as! UserListTableViewCell
        
        cell.emailLabel.text = userListData?.data![indexPath.row].email ?? ""
        cell.firstLastNameLabel.text = "\(userListData?.data![indexPath.row].first_name ?? "") \(userListData?.data![indexPath.row].last_name ?? "")"
        cell.avatarImageView.download(imageFromURL: URL(string: userListData?.data![indexPath.row].avatar ?? "")!)
        
        cell.selectionStyle = .none
        return cell
    }
    
}
