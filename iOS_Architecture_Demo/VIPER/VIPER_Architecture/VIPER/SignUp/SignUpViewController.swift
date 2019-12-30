//
//  SignUpViewController.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit
import SVProgressHUD

protocol SignUpProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class SignUpViewController: UIViewController, SignUpProtocol {
    //var interactor : SignUpInteractorProtocol?
    var presenter : SignUpPresentationProtocol?
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    
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
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        
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
        txtConfirmPassword.textType = .password
        phoneNumberTextField.textType = .phoneNumber
        firstNameTextField.textType = .normal
        lastNameTextField.textType = .normal
        
        emailTextField.text = "eve.holt@reqres.in"
        passwordTextField.text = "tEster123"
        txtConfirmPassword.text = "tEster123"

        firstNameTextField.text = "Tony"
        lastNameTextField.text = "Starc"
        phoneNumberTextField.text = "1234567890"
    }
    
    //MARK: button click actions
    
    @IBAction func buttonSignUp(_ sender: Any) {
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["email"] = emailTextField.text!
        requestDictionary["password"] = passwordTextField.text!
        requestDictionary["confirmPassword"] = txtConfirmPassword.text!
        requestDictionary["firstname"] = firstNameTextField.text!
        requestDictionary["lastname"] = lastNameTextField.text!
        requestDictionary["phone"] = phoneNumberTextField.text!
        self.presenter?.callSignupRequest(signupParams: requestDictionary)
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
    
    func showLoadingIndicator() {
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
}
