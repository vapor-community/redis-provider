import Cache
import Node
import JSON
import Core
import Transport

public struct RedisContext: Context {}

/// Uses an underlying Redbird
/// instance to conform to the CacheProtocol.
public final class RedisCache: CacheProtocol {
    public typealias ClientFactory = () throws -> Redis.TCPClient
    public let makeClient: ClientFactory
    private let context: RedisContext
    
    /// Creates a RedisCache from the address,
    /// port, and password credentials.
    ///
    /// Password should be nil if not required.
    public convenience init(hostname: String, port: Port, password: String? = nil, database: Int? = nil) throws {
        self.init {
            let client = try Client(
                hostname: hostname,
                port: port,
                password: password
            )
            
            guard let database = database else {
                return client
            }
            
            try client.command(try Command("select"), [database.description])
            return client
        }
    }
    
    /// Create a new RedisCache from a Redbird.
    public init(_ clientFactory: @escaping ClientFactory) {
        makeClient = clientFactory
        self.context = RedisContext()
    }
    
    /// Returns a key from the underlying Redbird
    /// instance by using the GET command.
    /// Try to deserialize else return original
    public func get(_ key: String) throws -> Node? {
        guard let bytes = try makeClient()
            .command(.get, [key])?
            .bytes
        else {
            return nil
        }
        
        do {
            return try JSON(bytes: bytes)
                .makeNode(in: context)
        } catch {
            return Node.bytes(bytes)
        }
    }
    
    /// Sets a key to the supplied value in the
    /// underlying Redbird instance using the
    /// SET command.
    /// Serializing Node if not a string
    public func set(_ key: String, _ value: Node, expiration: Date?) throws {
        let serialized: Bytes
        switch value.wrapped {
        case .string(let s):
            serialized = s.makeBytes()
        default:
            serialized = try JSON(value).serialize()
        }
        
        let key = key.makeBytes()
        let client = try makeClient()
        
        try client.command(.set, [key, serialized])
        if let exp = expiration {
            let time = Int(exp.timeIntervalSinceNow).description.makeBytes()
            try client.command(Command("expire"), [key, time])
        }
    }
    
    /// Deletes a key from the underlying Redbird
    /// instance using the DEL command.
    public func delete(_ key: String) throws {
        try makeClient().command(.delete, [key])
    }
}
