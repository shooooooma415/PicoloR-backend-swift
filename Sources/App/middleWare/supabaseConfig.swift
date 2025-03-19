import Fluent
import FluentPostgresDriver
import Vapor

public func configure(
    _ app: Application, hostname: String, username: String, password: String, database: String, port: Int
) throws {
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                
                tls: .disable
            )
        ),
        as: .psql
    )
}
