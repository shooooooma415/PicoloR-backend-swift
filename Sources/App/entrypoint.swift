import FluentPostgresDriver
import Logging
import NIOCore
import NIOPosix
import Vapor

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

        let hostname = Environment.get("DB_HOST") ?? "localhost"
        let username = Environment.get("DB_USER") ?? "postgres"
        let password = Environment.get("DB_PASSWORD") ?? "password"
        let database = Environment.get("DB_NAME") ?? "postgres"
        let portString = Environment.get("DB_PORT") ?? "1234"

        guard let port = Int(portString) else {
            fatalError("Invalid port number")
        }

        try configure(
            app, hostname: hostname, username: username, password: password, database: database,
            port: port)

        try routes(app)
        try await app.execute()
    }
}
