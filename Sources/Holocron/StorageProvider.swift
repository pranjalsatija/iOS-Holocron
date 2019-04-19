//
//  StorageProvider.swift
//  Holocron-iOS
//
//  Created by Pranjal Satija on 4/10/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

/// Performs an (optionally) throwing synchronous operation on an arbitrary background queue
/// and calls a completion block on the main queue once complete.
/// - parameter block: A block containing the operation to perform.
/// - parameter completion: The completion block to call when the operation is finished.
private func performAsynchronously<T>(_ block: @escaping () throws -> T, completion: @escaping (Result<T, Error>) -> ()) {
    OperationQueue().addOperation {
        do {
            let value: T = try block()
            OperationQueue.main.addOperation { completion(.success((value))) }
        } catch {
            OperationQueue.main.addOperation { completion(.failure(error)) }
        }
    }
}

/// An interface for a simple key value store.
public protocol StorageProvider {
    /// Deletes the value associated with the provided key.
    /// - parameter key: The key whose value should be deleted.
    func deleteValue(for key: String) throws
    
    /// Retrieves the value associated for a specific key.
    /// - parameter key: The key whose value to retrieve.
    /// - note: This function should return `nil` if the data found in the key value store cannot be converted to type T.
    func value<T: Decodable>(for key: String) throws -> T?
    
    /// Writes a value for a specific key.
    /// - parameter value: The value to store.
    /// - parameter key: The key to associate with `value`.
    func write<T: Encodable>(_ value: T, for key: String) throws
}

// MARK: Async Interface
extension StorageProvider {
    func deleteValue(for key: String, completion: @escaping (Result<Void, Error>) -> ()) {
        performAsynchronously({ try self.deleteValue(for: key) }, completion: completion)
    }
    
    func value<T: Decodable>(for key: String, completion: @escaping (Result<T?, Error>) -> ()) {
        performAsynchronously({ try self.value(for: key) }, completion: completion)
    }
    
    func write<T: Encodable>(_ value: T, for key: String, completion: @escaping (Result<Void, Error>) -> ()) {
        performAsynchronously({ try self.write(value, for: key) }, completion: completion)
    }
}
