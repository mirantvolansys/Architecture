//
//  LoginViewController.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import UIKit

protocol LoginProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
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
        let presenter = LoginPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
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
        self.showAlertView(withTitle: strTitle, message: strMessage)
    }
}
