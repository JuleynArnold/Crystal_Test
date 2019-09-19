require "./src/routing/route.cr"

#Define Custom Routes here


#View Routes
generateRouteClass("Login", "LoginController", "generateView", "./src/controller/login_controller.cr")

#No auth
generateRouteClass("GenerateSession", "Api", "login", "./src/api/api.cr")

#Required auth
generateRouteClass("FilePost", "Api" , "updateServer", "./src/api/api.cr")
generateRouteClass("Authenticate", "Api", "authenticate", "./src/api/api.cr")
