# Mobile_Architecture(MVP)

Reference Link :- https://themindstudios.com/blog/mvp-vs-mvc-vs-mvvm-vs-viper/

Modules Detail
============
1. Login Module : Login using Email and Password

2. Signup Module :  First Name, Last Name, Email, Password (Password should be min. 6 character length, it should contain Alphabets (With at least one capital letter & one small) and Numbers. No Special characters allowed), Phone Number, 
{ Validate Input fields, and fields according to their input types i.e. Email Address, Phone Number.}


3. User List Module : List of the Users after successful Login/Signup


MVP?
============
These classes are following.

*View:*
The view is a layout which task is to render the UI and to react to the user events. In the case of iOS, the View will consist of a Protocol that exposes the methods of the user’s events and a ViewController that is responsible for materializing and rendering the UI components and capturing the events that pass to the next component of the pattern, the presenter.

*Presenter:*
It is responsible for making a connector between the events emitted by the view and connecting them with the model.

*Model/Entity:*
Contains plain model classes used by the presenter.


**1.Login Module**
It has 3 files for login module.
1. LoginViewController.swift
2. LoginPresenter.swift
3. LoginEntity.swift



1. LoginViewController.swift
 - This file manage all UI for login like , email id and password textfields with sign In button.
 - Also have alert method for show alert to user. 


```
1. When user enter on sign in button first disctionary generated from email and password fields and called "callLoginRequest" method with passing parameter as dictionary which we have to use for API calling. 

2. When any error or validation failed then display alert called from presenter file and alert show via "displayAlert" method
```

2. LoginPresenter.swift
 - All logics , animations , communication (with view and entity) manage in this file.

```
1. When User call "callLoginRequest" method first in "validateLogin" method check all the validation. If validation is perfect then it will call method "callLoginApi" for api calling and if fails then show alert via calling view's "displayAlert" method.

2. Check all the validation is proper or not by "validateLogin" method

3.When got response from API then they passed it into "getLoginResponse" method. If any error in response then it will call view's "displayAlert" method and if got success then call "pushToUserList" method for present another controller.
```

3. LoginEntity.swift
- It is model of response which user will get from the Login's API.


**With same concept other 2 modules work**
- Sign Up
- User List
