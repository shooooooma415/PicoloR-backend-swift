import Vapor
import Fluent

final class AuthRepository {
    let db: Database
    
    init(db: Database) {
        self.db = db
    }
    
    func createUser(userName: UserName) -> EventLoopFuture<User?> {
        let sql:String = """
            INSERT INTO users (name)
            VALUES ($1)
            RETURNING id, name
            """
        
        return db.raw(sql)
            .bind(userName)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to create user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(nil)
            }
    }
    
    func deleteUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
        let sql:String = """
            DELETE FROM users
            WHERE id = $1
            RETURNING id, name
            """
        
        return db.raw(sql)
            .bind(userID)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to delete user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(nil)
            }
    }
    
    func findUserByUserID(userID: UserID) -> EventLoopFuture<User?> {
        let sql:String = """
            SELECT id, name
            FROM users
            WHERE id = $1
            """
        
        return db.raw(sql)
            .bind(userID)
            .all(decoding: User.self)
            .map { $0.first }
            .flatMapError { error in
                print("failed to find user: \(error)")
                return self.db.eventLoop.makeSucceededFuture(nil)
            }
    }
}