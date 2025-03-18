import Vapor

typealias UserName = String
typealias UserID = Int
typealias RoomID = Int

struct User: Content {
    let id: UserID
    let name: UserName
}

struct PostUserRequest: Content {
    let userName: UserName
}

struct PostUserResponse: Content {
    let userID: UserID
}

struct PostMemberRequest: Content {
    let roomID: RoomID
    let userID: UserID
}

struct DeleteUserRequest: Content {
    let userID: UserID
}