import Vapor
import Redbird

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

        guard let address = redis["address"]?.string else {
            throw ConfigError.missing(
                key: ["address"],
                file: "redis",
                desiredType: String.self
            )
        }

        guard let port = redis["port"]?.int else {
            throw ConfigError.missing(
                key: ["port"],
                file: "redis",
                desiredType: Int.self
            )
        }

        let password = redis["password"]?.string

        try self.init(
            address: address,
            port: port,
            password: password
        )
    }
}
