import Vapor
import cors

func routes(_ app: Application) throws {
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor"
    let database = Environment.get("DATABASE_NAME") ?? "vapor"

    try configure(
        app, hostname: hostname, username: username, password: password, database: database)

    try configureCORS(app)

    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    // app.post("controller/"){

    // }
}
