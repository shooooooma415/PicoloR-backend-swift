import Vapor
import FluentPostgresDriver

func routes(_ app: Application, db:any SQLDatabase) throws {
    let authRepo = AuthRepository(db: db)
    let roomRepo = RoomRepository(db: db)
    let colorRepo = ColorRepository(db: db)

    let authService = AuthService(authRepo: authRepo, roomRepo: roomRepo)
    let colorService = ColorService(colorRepo: colorRepo)
    

    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        return "Hello, world!"
    }


    app.post("controller/user") { req async throws -> PostUserResponse in
        let postUserRequest = try req.content.decode(PostUserRequest.self)
        let user = UserName(postUserRequest.userName)
        let createdUser = try await authService.createUser(userName: user)
        return PostUserResponse(userID: createdUser.id)
    }
}
