import Foundation

class AuthService {
    private let authRepo: AuthRepository
    private let roomRepo: RoomRepository

    init(authRepo: AuthRepository, roomRepo: RoomRepository) {
        self.authRepo = authRepo
        self.roomRepo = roomRepo
    }

    func createUser(userName: UserName) async throws -> User? {
        return try await authRepo.createUser(userName: userName)
    }

    func deleteUserByUserID(userID: UserID) async throws -> User? {
        return try await authRepo.deleteUserByUserID(userID: userID)
    }

    func registerMember(roomMember: RoomMember) async throws -> RoomMember? {
        return try await roomRepo.createRoomMember(roomMember: roomMember)
    }
}
