import Fluent
import FluentPostgresDriver
import Vapor

protocol ColorRepoProtocol {
    func findThemeColorsByRoomID(roomID: RoomID) async throws -> EventLoopFuture<[Color]>
    func findThemeColorByColorID(colorID: ColorID) async throws -> EventLoopFuture<Color?>
    func findColorIDsByRoomID(roomID: RoomID) async throws -> EventLoopFuture<[ColorID]>
}

final class ColorRepository: ColorRepoProtocol {
    let db: any SQLDatabase

    init(db: any SQLDatabase) {
        self.db = db
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
                print("failed to find theme colors: \(error)")
                return self.db.eventLoop.makeSucceededFuture([])
            }
        }


    func findThemeColorByColorID(colorID: ColorID) async throws -> EventLoopFuture<Color?> {
        let sql: SQLQueryString = """
            SELECT color, id
            FROM room_colors
            WHERE id = \(bind:colorID)
            """

        return db.raw(sql)
            .all(decoding: Color.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to find theme color: \(error)")
                return self.db.eventLoop.makeSucceededFuture(nil)
            }
    }

    func findColorIDsByRoomID(roomID: RoomID) async throws -> EventLoopFuture<[ColorID]> {
        let sql: SQLQueryString = """
            SELECT id
            FROM room_colors
            WHERE room_id = \(bind:roomID)
            """

        return db.raw(sql)
            .all(decoding: ColorID.self)
            .flatMapError { error in
                print("failed to find colorIDs: \(error)")
                return self.db.eventLoop.makeSucceededFuture([])
            }
    }

}