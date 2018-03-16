//
//  Storable+Defaults.swift
//  Holocron-iOS
//
//  Created by Will McGinty on 3/16/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

//MARK: String
extension String: Storable {
    
    public func encoded() throws -> Data {
        guard let data = data(using: .utf8) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "The string \(self) could not be UTF8 encoded into Data."))
        }
        return data
    }
    
    public static func decoded(from data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The bytes [\(data)] could not be UTF8 decoded into a String."))
        }
        return string
    }
}

//MARK: Codable
public extension Storable where Self: Codable {
    
    func encoded() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decoded(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}