import Vapor
import Logging
import NIOCore
import NIOPosix

@main
enum Entrypoint {
    static func main() async throws {
        let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
        let username = Environment.get("DATABASE_USERNAME") ?? "vapor"
        let password = Environment.get("DATABASE_PASSWORD") ?? "vapor"
        let database = Environment.get("DATABASE_NAME") ?? "vapor"

    try configure(
        app, hostname: hostname, username: username, password: password, database: database)

    try configureCORS(app)
        do {
            try await configure(app)
            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
}
