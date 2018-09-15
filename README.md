
# Project Title
SOCIALEO - A test app for the mobile team at ENABLON

# Assignment
Create a mobile app with one view showing the list of the most recent photos posted on Instagram with the account below, following these guidelines:

- list must show the photos posted by the account provided below
- some photo metadata (title, comments, dates, number of likes…) should be displayed
- list must be built to show any number of photos

# Getting Started
This is a test app as part of the interview process at **ENABLON France**. 
To get started you will need to have a valid Account access token to connect to Instagram API and minimum iOS 11.4 installed and Xcode 9.0.

## Others adding more features to the app

### Adding liking / unliking functionality
To add the the like function, you will first need to create a developer account with Instagram, then register your app, please visit [Instagram developer](https://www.instagram.com/developer/) for more information and for the documentation. 

Once you have setup your application and allow user a way to authenticate themselves, you can start creating you like functionality.

**The like functionality could be done as follow:**
  - [x] have a like button on your custom cell
  - [x] a variable to keep tract of the post id
  - [x] a variable to keep tract of your like status for the post, such as as bool
  - [x] a functiontion to triger according to the bool variable status, for isntance if the user already have liked the post, the button should trigger the unlike functionality
- once the user has triggered and action (like /unlike), the info will be sent to instagram database with the following info: 
  - [x] userid
  - [x] postid
  - [x] timestamp of the action
  - [x] check if the user is still log in
  
- instagram will add/remove the postid to the user likes and update the likes count accordingly
- an observer in the app will then trigger a new fetch in the background to reflect the correct info available
- the app will then reload the list to show the up-to-date info to the user

**The comment functionality could be done as follow (see the test app, as the basic functionality is already done):**
- [x] make a comment view controller with a list collectioncontroller (tableview or collectionview)
  - [x] add an inputview (textview)
  - [x] link everything to the commenVC
  - [x] a convenient variable to get the postid
  - [x] a convenient variable to get the userid
  - [x] check if the user is still log in - to avoid no **userid** available
  
- once the user has press the send button, check if the textfield is **not empty** (if it is do nothing)
- if textview not empty, userid and postid aren't nil -> create a post object with required info and POST the infoto Instagram server with a callback to update the UI accordingly. For isntance once the post has been sent with success, clear the textview
- an observer in the app will then trigger a new fetch in the background to reflect the correct info available
- the app will then reload the list to show the up-to-date info to the user

# Added bonus to the assignement
 I decide to add some features that could directly benefit ENABLON apps.



