import Vapor


func routes(_ app: Application) throws {

    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        return "Hello, world!"
    }


    // app.post("controller/"){

    // }
}
