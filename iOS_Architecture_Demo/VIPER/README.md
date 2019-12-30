# Mobile_Architecture(VIPER)

Reference Link :- https://themindstudios.com/blog/mvp-vs-mvc-vs-mvvm-vs-viper/

Modules Detail
============
1. Login Module : Login using Email and Password

2. Signup Module :  First Name, Last Name, Email, Password (Password should be min. 6 character length, it should contain Alphabets (With at least one capital letter & one small) and Numbers. No Special characters allowed), Phone Number, 
{ Validate Input fields, and fields according to their input types i.e. Email Address, Phone Number.}


3. User List Module : List of the Users after successful Login/Signup


VIPER?
============
These classes are following.

*View:*
Class that has all the code to show the app interface to the user and get their responses. Upon receiving a response View alerts the Presenter.

*Presenter:*
It gets user response from the View and work accordingly. Only class to communicate with all the other components. Calls the router for wire-framing, Interactor to fetch data (network calls or local data calls), view to update the UI.

*Interactor:* 
Has the business logics of an app. Primarily make API calls to fetch data from a source. Responsible for making data calls but not necessarily from itself.

*Router:*
Does the wire-framing. Listens from the presenter about which screen to present and executes that.

*Entity:*
Contains plain model classes used by the interactor.


**1.Login Module**
It has 5 files for login module.
1. LoginViewController.swift
2. LoginPresenter.swift
3. LoginInteractor.swift
4. LoginEntity.swift
5. LoginRouter.swift



1. LoginViewController.swift
 - This file manage all UI for login like , email id and password textfields with sign In button.
 - Also have alert method for show alert to user. 


```
1. When user enter on sign in button first disctionary generated from email and password fields and called "callLoginRequest" method with passing parameter as dictionary which we have to use for API calling. 

2. When any error or validation failed then display alert called from presenter file and alert show via "displayAlert" method
```

2. LoginPresenter.swift
 - All logics(except business logic) , animations , communication (with view , interactor and router) manage in this file.

```
1. When User call "callLoginRequest" method first in "validateLogin" method check all the validation. If validation is perfect then it will call method of interactor "callLoginApi" for api calling and if fails then show alert via calling view's "displayAlert" method.

2. Check all the validation is proper or not by "validateLogin" method

3.When interactor got response from API then they passed it into presenter's "getLoginResponse" method. If any error in response then it will call view's "displayAlert" method and if got success then call Router's "pushToUserList" method for present another controller.
```

3. LoginInteractor.swift
- All business logics like API calling that written in this file. This file only communicate with "LoginPresenter.swift" file.

```
1. It has "callLoginApi" method. In this method API for login called for response. When presenter call this method then it works. It will pass response to presenter file back because presenter can pass it to the view and can update UI. 
```

4. LoginEntity.swift
- It is model of response which user will get from the Login's API.

5. LoginRouter.swift
- All the navigations developer have to manage in this file.


```
1. It has "pushToUserList" method. By this when user got success response then presenter call this method and ask for navigation to User listing controller.  
```



**With same concept other 2 modules work**
- Sign Up
- User List
