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
        
        let encoding = redis["encoding"]?.string
        
        if let url = redis["url"]?.string {
            try self.init(url: url, encoding: encoding)
            
            try makeClientDatabase(redis: redis)
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
            
            try makeClientDatabase(redis: redis)
        }
    }
    
    private func makeClientDatabase(redis: [String: Config]) throws {
        if let database = redis["database"]?.int {
            try makeClient().command(try Command("database"), [database.description])
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
  
    //accepts a heroku redis connection string in the format of:
    //redis://h:PASSWORD@URL:PORT
    public convenience init(url: String, encoding: String?) throws {
        let uri = try URI(url)
        
        let host = uri.hostname
        let password = uri.userInfo?.info
        guard let port = uri.port else {
            throw ConfigError.missing(key: ["port"], file: "redis", desiredType: Port.self)
        }
        let database = Int(uri.path)
        
        try self.init(
            hostname: host,
            port: Port(port),
            password: password,
            database: database
        )
    }
}
