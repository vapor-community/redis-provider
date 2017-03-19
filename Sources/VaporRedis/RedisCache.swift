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
    public convenience init(hostname: String, port: Port, password: String? = nil) throws {
        self.init {
            return try Client(
                hostname: hostname,
                port: port,
                password: password
            )
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
    public func set(_ key: String, _ value: Node) throws {
        let bytes: Bytes
        switch value.wrapped {
        case .array, .object:
            bytes = try JSON(value).serialize()
        case .number(let number):
            bytes = number.description.makeBytes()
        default:
            guard let b = value.bytes else {
                throw RedisError.general("Unable to serialize value for key '\(key)'")
            }
            bytes = b
        }
        
        let key = key.makeBytes()
        try makeClient().command(.set, [key, bytes])
    }
    
    /// Deletes a key from the underlying Redbird
    /// instance using the DEL command.
    public func delete(_ key: String) throws {
        try makeClient().command(.delete, [key])
    }
}
