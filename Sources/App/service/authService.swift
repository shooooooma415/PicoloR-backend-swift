import Foundation
import NIOCore

final class AuthService {
    private let authRepo: any AuthRepoProtocol
    private let roomRepo: any RoomRepoProtocol

    init(authRepo: any AuthRepoProtocol, roomRepo: any RoomRepoProtocol) {
        self.authRepo = authRepo
        self.roomRepo = roomRepo
    }

    func createUser(userName: UserName) async throws -> User {
        let createdUserFuture: EventLoopFuture<User?> = try await authRepo.createUser(userName: userName)
        let userOpt: User? = try await createdUserFuture.get()
        guard let user = userOpt else {
            throw NSError(domain: "AuthServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])
        }
        return user
    }

    func deleteUserByUserID(userID: UserID) async throws -> User {
        let deletedUserFuture: EventLoopFuture<User?> = try await authRepo.deleteUserByUserID(userID: userID)
        let userOpt: User? = try await deletedUserFuture.get()
        guard let user = userOpt else {
            throw NSError(domain: "AuthServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User deletion failed"])
        }
        return user
    }

    func registerMember(roomMember: RoomMember) async throws -> EventLoopFuture<RoomMember?> {
        return try await roomRepo.createRoomMember(user: roomMember)
    }
}
