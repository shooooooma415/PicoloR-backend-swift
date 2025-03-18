import Foundation
import PostgresNIO
import NIO

func loadEnvFile() throws {
    var currentDir = FileManager.default.currentDirectoryPath
    while true {
        let envPath = URL(fileURLWithPath: currentDir).appendingPathComponent(".env").path
        if FileManager.default.fileExists(atPath: envPath) {
            let envData = try String(contentsOfFile: envPath)
            let envVars = envData.split(separator: "\n")
            for envVar in envVars {
                let keyValue = envVar.split(separator: "=", maxSplits: 1)
                if keyValue.count == 2 {
                    setenv(String(keyValue[0]), String(keyValue[1]), 1)
                }
            }
            return
        }
        let parentDir = URL(fileURLWithPath: currentDir).deletingLastPathComponent().path
        if parentDir == currentDir {
            break
        }
        currentDir = parentDir
    }
    throw NSError(domain: "EnvFileError", code: 1, userInfo: [NSLocalizedDescriptionKey: ".envファイルが見つかりませんでした。"])
}

struct SupabaseConfig {
    let host: String
    let port: Int
    let user: String
    let password: String
    let database: String
}

func connectDB(config: SupabaseConfig? = nil) async throws -> EventLoopGroupConnectionPool<PostgresConnectionSource> {
    if ProcessInfo.processInfo.environment["RENDER"] == nil {
        do {
            try loadEnvFile()
        } catch {
            print("Warning: \(error.localizedDescription)")
        }
    }

    let dbConfig: SupabaseConfig
    if let config = config {
        dbConfig = config
    } else {
        guard let host = ProcessInfo.processInfo.environment["DB_HOST"],
              let portString = ProcessInfo.processInfo.environment["DB_PORT"],
              let port = Int(portString),
              let user = ProcessInfo.processInfo.environment["DB_USER"],
              let password = ProcessInfo.processInfo.environment["DB_PASSWORD"],
              let database = ProcessInfo.processInfo.environment["DB_NAME"] else {
            throw NSError(domain: "DBConfigError", code: 1, userInfo: [NSLocalizedDescriptionKey: "環境変数に必要なDB接続情報が不足しています。"])
        }
        dbConfig = SupabaseConfig(host: host, port: port, user: user, password: password, database: database)
    }

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let configuration = PostgresConnection.Configuration(
        connection: .init(
            host: dbConfig.host,
            port: dbConfig.port,
            username: dbConfig.user,
            password: dbConfig.password,
            database: dbConfig.database,
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    )
    let connectionPool = EventLoopGroupConnectionPool(
        source: PostgresConnectionSource(configuration: configuration),
        on: eventLoopGroup
    )

    do {
        let conn = try await connectionPool.withConnection { conn in
            conn.simpleQuery("SELECT NOW()")
        }
        print(conn)
    } catch {
        throw NSError(domain: "DBConnectionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "fail to connect supabase: \(error.localizedDescription)"])
    }

    return connectionPool
}
