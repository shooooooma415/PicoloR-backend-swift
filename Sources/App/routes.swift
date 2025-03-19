import Vapor
import FluentPostgresDriver

func routes(_ app: Application) throws {
    let authRepo = AuthRepository()
    let roomRepo = RoomRepository()
    // let colorRepo = ColorRepository(db: db)

    let authService = AuthService(authRepo: authRepo, roomRepo: roomRepo)
    // let colorService = ColorService(colorRepo: colorRepo)
    

    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        return "Hello, world!"
    }


    app.post("controller", "user") { req async throws -> PostUserResponse in
        let postUserRequest = try req.content.decode(PostUserRequest.self)
        let user = UserName(postUserRequest.userName)
        let createdUser = try await authService.createUser(userName: user, db: req.db as! (any PostgresDatabase) as! SQLDatabase)
        return PostUserResponse(userID: createdUser.id)
    }

    // app.post("controller", "room") { req async throws -> HTTPStatus in
    //     let postMemberRequest = try req.content.decode(PostMemberRequest.self)
    //     let roomMember = RoomMember(roomID: postMemberRequest.roomID, userID: postMemberRequest.userID)
    //     let createdMember = try await authService.registerMember(roomMember: roomMember)
    //     return .ok
    // }

    // app.delete("controller", "user") { req async throws -> HTTPStatus in
    //     let deleteUserRequest = try req.content.decode(DeleteUserRequest.self)
    //     let deletedUser = try await authService.deleteUserByUserID(userID: deleteUserRequest.userID)
    //     return .ok
    // }

    // app.get("controller", "color") { req async throws -> GetColorResponse in
    //     let roomID = try req.query.get(Int.self, at: "roomID")
    //     let colors = try await colorService.getThemeColors(roomID: roomID)
    //     let response = GetColorResponse(themeColor: colors)
    //     return response
    // }
}
