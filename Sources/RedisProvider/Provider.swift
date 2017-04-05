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
        
        let encoding = redis["encoding"]?.string
        
        if let url = redis["url"]?.string {
            try self.init(url: url, encoding: encoding)
            
            if let database = redis["database"]?.int {
                try makeClient().command(try Command("database"), [database.description])
            }
        } else {
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
                try makeClient().command(try Command("database"), [database.description])
            }
        }
    }
    
    public convenience init(url: String, encoding: String?) throws {
        
    }
}
