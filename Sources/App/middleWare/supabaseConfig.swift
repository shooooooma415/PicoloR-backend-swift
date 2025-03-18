import Fluent
import FluentPostgresDriver
import Vapor

public func configure(
    _ app: Application, hostname: String, username: String, password: String, database: String
) throws {
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
