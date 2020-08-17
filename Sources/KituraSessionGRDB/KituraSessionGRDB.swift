import Foundation
import KituraSession
import GRDB

struct Session: FetchableRecord, PersistableRecord, Codable {
    let id: String
    let data: Data

    static let idColumn = Column("id")
    static let databaseTableName = "sessions"
}

public class KituraSessionGRDBStore: Store {
    public enum Failures: LocalizedError {
        case unableToFindSessionId
    }
    private let pool: DatabasePool

    public init(path: String) throws {
        self.pool = try DatabasePool(path: path)
        try self.performMigrations()
    }

    public func load(sessionId: String, callback: @escaping (Data?, NSError?) -> Void) {
        do {
            try self.pool.read { db in
                if let session = try Session.fetchOne(db, key: sessionId) {
                    callback(session.data, nil)
                } else {
                    callback(nil, nil)
                }
            }
        } catch {
            callback(nil, error as NSError)
        }
    }

    public func save(sessionId: String, data: Data, callback: @escaping (NSError?) -> Void) {
        let session = Session(id: sessionId, data: data)

        do {
            try self.pool.write { db in
                try session.save(db)
                callback(nil)
            }
        } catch {
            callback(error as NSError)
        }
    }

    public func touch(sessionId: String, callback: @escaping (NSError?) -> Void) {
        callback(nil)
    }

    public func delete(sessionId: String, callback: @escaping (NSError?) -> Void) {
        do {
            _ = try self.pool.write { db in
                try Session.deleteAll(db, keys: [ sessionId ])
            }
            callback(nil)
        } catch {
            callback(error as NSError)
        }
    }

    // MARK: Private Methods

    private func performMigrations() throws {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("v1") { db in
            try db.create(table: Session.databaseTableName) { t in
                t.column("id", .text).primaryKey()
                t.column("data", .blob)
            }
        }
        try migrator.migrate(self.pool)
    }


}
