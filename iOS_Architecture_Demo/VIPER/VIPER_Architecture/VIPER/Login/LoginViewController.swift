//
//  LoginViewController.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoginProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
    func displayAlertSuccess(strTitle : String, strMessage : String, completion : @escaping (Int) -> Void)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class LoginViewController: UIViewController, LoginProtocol {
    //var interactor : LoginInteractorProtocol?
    var presenter : LoginPresentationProtocol?
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        
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
        
        emailTextField.textType = .emailAddress
        passwordTextField.textType = .password
        
        emailTextField.text = "eve.holt@reqres.in"
        passwordTextField.text = "tEster123"
    }
    
    //MARK: button click actions
    
    @IBAction func buttonSignIn(_ sender: Any) {
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["email"] = emailTextField.text!
        requestDictionary["password"] = passwordTextField.text!
        self.presenter?.callLoginRequest(loginParams: requestDictionary)
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
        self.showAlertView(withTitle: strTitle, message: strMessage)
        
    }
    
    func displayAlertSuccess(strTitle : String, strMessage : String, completion : @escaping (Int) -> Void){
        
        // Create the actions
        let okAction = UIAlertAction(title: "Navigate", style: UIAlertAction.Style.default) {
            UIAlertAction in
            completion(1)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            completion(2)
        }
    
        self.showAlertView(withTitle: strTitle, message: strMessage, withActions: [okAction,cancelAction])
    }
    
    func showLoadingIndicator() {
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
}
