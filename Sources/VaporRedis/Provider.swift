import Vapor
import Transport

/// Provides a RedisCache object to Vapor
/// when added to a Droplet.
public final class Provider: Vapor.Provider {
    public init(config: Config) throws {}

    public func boot(_ drop: Droplet) throws {
        try drop.addConfigurable(cache: RedisCache.self, name: "redis")
    }

    public func beforeRun(_: Droplet) throws {}
}

extension RedisCache: ConfigInitializable {
    public convenience init(config: Config) throws {
        guard let redis = config["redis"]?.object else {
            throw ConfigError.missingFile("redis")
        }

        guard let hostname = redis["hostname"]?.string else {
            throw ConfigError.missing(
                key: ["hostname"],
                file: "redis",
                desiredType: String.self
            )
        }

        guard let port = redis["port"]?.int?.port else {
            throw ConfigError.missing(
                key: ["port"],
                file: "redis",
                desiredType: Port.self
            )
        }

        let password = redis["password"]?.string

        try self.init(
            hostname: hostname,
            port: port,
            password: password
        )
        
        if let database = redis["database"]?.int {
            try client.command(try Command("database"), [database.description])
        }
    }
}
