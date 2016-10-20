import Vapor
import Redbird

/**
    Provides a RedisCache object to Vapor
    when added to a Droplet.
*/
public final class Provider: Vapor.Provider {
    public var provided: Providable { return Providable(cache: cache) }

    public enum Error: Swift.Error {
        case invalidRedisConfig(String)
    }

    private let cache: RedisCache
    /**
        Create the provider using manual, hard-coded
        configuration values.
    */
    public init(address: String, port: Int, password: String? = nil) throws {
        cache = try RedisCache(address: address, port: port, password: password)
    }

    /**
        Create the provider using the Droplet
        configuration files. This will happen
        automatically if passed as a Type to Vapor.
    */
    public convenience init(config: Config) throws {
        guard let redis = config["redis"]?.object else {
            throw Error.invalidRedisConfig("No redis.json file.")
        }

        guard let address = redis["address"]?.string else {
            throw Error.invalidRedisConfig("No address.")
        }

        guard let port = redis["port"]?.int else {
            throw Error.invalidRedisConfig("No port.")
        }

        let password = redis["password"]?.string

        try self.init(address: address, port: port, password: password)
    }

    public func boot(_ droplet: Droplet) {
        droplet.cache = cache
    }

    public func afterInit(_ droplet: Droplet) {}
    public func beforeRun(_ droplet: Droplet) {}
}
