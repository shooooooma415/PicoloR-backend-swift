import Fluent
import FluentPostgresDriver
import Vapor


protocol AuthRepoProtocol {
    func createUser(userName: UserName, db: any SQLDatabase) async throws -> EventLoopFuture<User>
    // func deleteUserByUserID(userID: UserID) async throws -> EventLoopFuture<User?>
    // func findUserByUserID(userID: UserID) async throws -> EventLoopFuture<User?>
}

final class AuthRepository: AuthRepoProtocol {
    // let db: any SQLDatabase

    // init(db: any SQLDatabase) {
    //     self.db = db
    // }

    func createUser(userName: UserName, db: any SQLDatabase) -> EventLoopFuture<User> {
        let query:SQLQueryString = """
            INSERT INTO users (name) VALUES \(userName) RETURNING id
            """

        let result = try db.raw(query)
            .first(decoding: User.self)
            .unwrap(or: Abort(.notFound, reason: "指定されたIDのTodoが見つかりません"))
        return result
    }

    // func deleteUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
    //     let sql: SQLQueryString = """
    //         DELETE FROM users
    //         WHERE id = \(bind:userID)
    //         RETURNING id, name
    //         """

    //     return db.raw(sql)
    //         .all(decoding: User.self)
    //         .map { $0.first }
    //         .flatMapError { error in
    //             print("failed to delete user: \(error)")
    //             return self.db.eventLoop.makeSucceededFuture(User(id: -1, name: "error"))
    //         }
    // }

    // func findUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
    //     let sql: SQLQueryString = """
    //         SELECT id, name
    //         FROM users
    //         WHERE id = \(bind:userID)
    //         """

    //     return db.raw(sql)
    //         .all(decoding: User.self)
    //         .map { $0.first }
    //         .flatMapError { error in
    //             print("failed to find user: \(error)")
    //             return self.db.eventLoop.makeSucceededFuture(User(id: -1, name: "error"))
    //         }
    // }
}
