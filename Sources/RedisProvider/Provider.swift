import Vapor
import Transport
import URI

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
        
        if let url = redis["url"]?.string {
            let encoding = redis["encoding"]?.string
            try self.init(url: url, encoding: encoding)
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
            let database = redis["database"]?.int
            
            try self.init(
                hostname: hostname,
                port: port,
                password: password,
                database: database
            )
        }
    }
    
    //accepts a heroku redis connection string in the format of:
    //redis://user:password@hostname:port/database
    public convenience init(url: String, encoding: String?) throws {
        let uri = try URI(url)
        
        guard uri.scheme == "redis" else {
            throw ConfigError.missing(key: ["url"], file: "redis", desiredType: String.self)
        }
        
        let host = uri.hostname
        let password = uri.userInfo?.info
        guard let port = uri.port else {
            throw ConfigError.missing(key: ["url.port"], file: "redis", desiredType: Port.self)
        }
        
        let database = Int(uri.path.components(separatedBy: "/").last ?? "")
        
        try self.init(
            hostname: host,
            port: Port(port),
            password: password,
            database: database
        )
    }
}
