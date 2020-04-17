require "./src/routing/route.cr"

#Define Custom Routes here


#View Routes
generateRouteClass("Login", "LoginController", "generateView", "./src/controller/login_controller.cr")

#No auth
generateRouteClass("CreateUser", "CreateUserController", "createUser", "./src/controller/createuser_controller.cr") #Creates a new user
generateRouteClass("Authenticate", "Api", "authenticate", "./src/api/api.cr") #Returns a session id for the user

#Required auth
generateRouteClass("FilePost", "Api" , "updateServer", "./src/api/api.cr") #Adds files to the users individual directory
generateRouteClass("Authorize", "Api", "authorize", "./src/api/api.cr") #Ensures that the sessionid is still valid and the action can
generateRouteClass("FileGet", "Api", "updateClient", "./src/api/api.cr")
