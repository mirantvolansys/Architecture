# Mobile_Architecture(MVVM)


Modules Detail
============
1. Login Module : Login using Email and Password

2. Signup Module :  First Name, Last Name, Email, Password (Password should be min. 6 character length, it should contain Alphabets (With at least one capital letter & one small) and Numbers. No Special characters allowed), Phone Number, 
{ Validate Input fields, and fields according to their input types i.e. Email Address, Phone Number.}

3. User List Module : List of the Users after successful Login/Signup


MVVM
=====

*Model:*
Model represents the data in the app which is used for storing domain/app-specific information. Only the ViewModel talks to the Model. Only the ViewModel talks to the View/view controller.

*View:*
The view is a layout whose task is to render the UI and to react to the user events. View is used to display the data (received from Model or ViewModel). So basically XIB,Storyboard acts as a View.

*ViewModel:*
This class is responsible for making interaction between ViewController and Model class. All events and business logic will get performed in this class. All validations should also get performed at ViewModel level.

iOS MVVM Demo-application Understanding
=======================================

1. Login Module:

* Model: 'Login' model has one property named "token" which will get set when Login API responds success.
```
class Login : Mappable {
    var token:String?
}
```

Note : The 'Mappable' protocol is used to map API response with Login model class.

* ViewModel : 'LoginViewModel' will perform validations on input fields and then make a server request to check entered credentials. On successful validation, server will respond 'token' value which will get passed to ViewController.
```
class LoginViewModel {
    var emailAddress:String?
    var password:String?
    func validateUserInput(success:@escaping (Bool) -> Void, failure:@escaping (String) -> Void) {}
}
```

* LoginVC : This viewcontroller class will interact with 'LoginViewModel' to perform validations on textfields and, after that, make an API call to get token value.

e.g. Perform input validation check and then validate credentials over Server.

```
let loginVM: LoginViewModel = LoginViewModel()
loginVM.validateUserInput(success: { (status) in
self.performUserLogin()
}) { (alertMsg) in
self.showErrorAlert(withMessage: alertMsg)
}
```

Sameway we can follow this pattern for remaining two modules : Signup Module & User List Module

For More details, pls refer : [iOS Design Patterns](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)