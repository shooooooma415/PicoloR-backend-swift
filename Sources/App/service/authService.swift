import Foundation
import NIOCore

final class AuthService {
    private let authRepo: any AuthRepoProtocol
    private let roomRepo: any RoomRepoProtocol

    init(authRepo: any AuthRepoProtocol, roomRepo: any RoomRepoProtocol) {
        self.authRepo = authRepo
        self.roomRepo = roomRepo
    }

    func createUser(userName: UserName) async throws -> EventLoopFuture<User?> {
        return try await authRepo.createUser(userName: userName)
    }

    func deleteUserByUserID(userID: UserID) async throws -> EventLoopFuture<User?> {
        return try await authRepo.deleteUserByUserID(userID: userID)
    }

    func registerMember(roomMember: RoomMember) async throws -> EventLoopFuture<RoomMember?> {
        return try await roomRepo.createRoomMember(user: roomMember)
    }
}
