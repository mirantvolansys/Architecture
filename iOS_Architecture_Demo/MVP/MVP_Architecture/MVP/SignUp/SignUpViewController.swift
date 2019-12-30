//
//  SignUpViewController.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit

protocol SignUpProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
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
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    
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
        let presenter = SignUpPresenter()
        
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
        confirmPasswordTextField.textType = .password
        phoneNumberTextField.textType = .phoneNumber
        firstNameTextField.textType = .normal
        lastNameTextField.textType = .normal
        
        confirmPasswordTextField.placeholder = "Confirm Password"
        
        emailTextField.text = "eve.holt@reqres.in"
        passwordTextField.text = "tEster123"
        confirmPasswordTextField.text = "tEster123"
        firstNameTextField.text = "Tony"
        lastNameTextField.text = "Starc"
        phoneNumberTextField.text = "1234567890"
    }
    
    //MARK: button click actions
    
    @IBAction func buttonSignUp(_ sender: Any) {
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["email"] = emailTextField.text!
        requestDictionary["password"] = passwordTextField.text!
        requestDictionary["confirmPassword"] = confirmPasswordTextField.text!
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
        self.showAlertView(withTitle: strTitle, message: strMessage)
    }
}
