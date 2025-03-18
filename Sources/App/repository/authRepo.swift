import Vapor
import Fluent
import SQLKit
import FluentPostgresDriver

protocol AuthRepoProtocol {
    func createUser(userName: UserName) async throws -> EventLoopFuture<User?>
    func deleteUserByUserID(userID: UserID) async throws -> EventLoopFuture<User?>
    func findUserByUserID(userID: UserID) async throws -> EventLoopFuture<User?>
}

final class AuthRepository: AuthRepoProtocol {
    let db: any SQLDatabase
    
    init(db: any SQLDatabase) {
        self.db = db
    }
    
    func createUser(userName: UserName) -> EventLoopFuture<User?> {
        let sql: SQLQueryString = """
            INSERT INTO users (name)
            VALUES \(bind:userName)
            RETURNING id, name
            """
        
        return db.raw(sql)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to create user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(User(id: -1, name: "error"))
            }
    }
    
    func deleteUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
        let sql: SQLQueryString = """
            DELETE FROM users
            WHERE id = \(bind:userID)
            RETURNING id, name
            """
        
        return db.raw(sql)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to delete user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(User(id: -1, name: "error"))
            }
    }
    
    func findUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
        let sql: SQLQueryString = """
            SELECT id, name
            FROM users
            WHERE id = \(bind:userID)
            """
        
        return db.raw(sql)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to find user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(User(id: -1, name: "error"))
            }
    }
}
