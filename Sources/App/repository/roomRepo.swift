import Vapor
import Fluent
import FluentPostgresDriver

protocol RoomRepoProtocol {
    func createRoomMember(user: RoomMember,db: any SQLDatabase) async throws -> EventLoopFuture<RoomMember?>
}

final class RoomRepository: RoomRepoProtocol {
    // let db: any SQLDatabase
    
    // init(db: any SQLDatabase) {
    //     self.db = db
    // }
    
    func createRoomMember(user: RoomMember,db: any SQLDatabase) -> EventLoopFuture<RoomMember?> {
        let sql: SQLQueryString = """
            INSERT INTO room_members (user_id, room_id)
            VALUES \(bind:user.userID), \(bind:user.roomID)
            RETURNING user_id, room_id
            """
        
        return db.raw(sql)
            .all(decoding: RoomMember.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to create room member: \(error)")
                return db.eventLoop.makeSucceededFuture(RoomMember(roomID: -1, userID: -1))
            }
    }
}
