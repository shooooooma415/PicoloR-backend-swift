import Fluent
import FluentPostgresDriver
import Vapor

final class ColorRepository {
    let db: any SQLDatabase

    init(db: any SQLDatabase) {
        self.db = db
    }

    func deleteThemeColors(roomID: RoomID) async throws -> EventLoopFuture<RoomID?> {
        let sql: SQLQueryString = """
            DELETE FROM room_colors
            WHERE room_id = \(bind:roomID)
            RETURNING room_id
            """

        return db.raw(sql)
            .all(decoding: RoomID.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to delete user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(RoomID(-1))
            }

        func findThemeColorsByRoomID(roomID: RoomID) async throws -> EventLoopFuture<[Color]> {
            let sql: SQLQueryString = """
                SELECT room_id, color_id
                FROM room_colors
                WHERE room_id = \(bind:roomID)
                """

            return db.raw(sql)
                .all(decoding: Color.self)
                .flatMapError { error in
                    print("failed to create room member: \(error)")
                    return self.db.eventLoop.makeSucceededFuture([])
                }
        }
    }
}
