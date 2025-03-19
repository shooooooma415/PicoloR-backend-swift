import Vapor
import Logging
import NIOCore
import NIOPosix
import FluentPostgresDriver

@main
struct Entrypoint {
    static func main() async throws {
        let app = try await Application.make(Environment.detect())

        defer { 
            Task.detached { 
                do {
                    try await app.asyncShutdown()
                } catch {
                    print("Shutdown error: \(error)")
                }
            }
        }
        
        app.middleware.use(CORSMiddleware.default)
        
        let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
        let username = Environment.get("DATABASE_USERNAME") ?? "vapor"
        let password = Environment.get("DATABASE_PASSWORD") ?? "vapor"
        let database = Environment.get("DATABASE_NAME") ?? "vapor"
        
        try configure(app, hostname: hostname, username: username, password: password, database: database)

        

        try routes(app, db:app.db)
        try await app.execute()
    }
}
