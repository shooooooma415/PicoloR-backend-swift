import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor"
    let database = Environment.get("DATABASE_NAME") ?? "vapor"
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: hostname,
                username: username,
                password: password,
                database: database,
                tls: .disable
            )
        ),
        as: .psql
    )
    
}