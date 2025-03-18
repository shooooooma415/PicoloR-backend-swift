import Vapor
import Fluent

final class RoomRepository {
    let db: Database
    
    init(db: Database) {
        self.db = db
    }
    
    func createRoomMember(user: RoomMember) -> EventLoopFuture<RoomMember?> {
        let sql = """
            INSERT INTO room_members (user_id, room_id)
            VALUES ($1, $2)
            RETURNING user_id, room_id
            """
        
        return db.raw(sql)
            .bind(user.userID)
            .bind(user.roomID)
            .all(decoding: RoomMember.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to create room member: \(error)")
                return self.db.eventLoop.makeSucceededFuture(nil)
            }
    }
}