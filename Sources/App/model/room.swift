import Vapor

struct Room: Content {
    let roomID: RoomID
    let isStart: Bool
    let isFinish: Bool
    let startAt: Date
}

struct RoomMember: Content {
    let roomID: RoomID
    let userID: UserID
}

