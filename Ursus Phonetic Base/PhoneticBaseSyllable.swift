//
//  PhoneticBaseSyllable.swift
//  Alamofire
//
//  Created by Daniel Clelland on 15/07/20.
//

import Foundation

public enum PhoneticBaseSyllable: CaseIterable, RawRepresentable {
    
    case prefix(PhoneticBasePrefix)
    case suffix(PhoneticBaseSuffix)
    
    public static var allCases: [PhoneticBaseSyllable] {
        let prefixes = PhoneticBasePrefix.allCases.map { prefix in
            return PhoneticBaseSyllable.prefix(prefix)
        }
        
        let suffixes = PhoneticBaseSuffix.allCases.map { suffix in
            return PhoneticBaseSyllable.suffix(suffix)
        }
        
        return prefixes + suffixes
    }
    
    public init?(rawValue: String) {
        switch (PhoneticBasePrefix(rawValue: rawValue), PhoneticBaseSuffix(rawValue: rawValue)) {
        case (.some(let prefix), .none):
            self = .prefix(prefix)
        case (.none, .some(let suffix)):
            self = .suffix(suffix)
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .prefix(let prefix):
            return prefix.rawValue
        case .suffix(let suffix):
            return suffix.rawValue
        }
    }
    
}

extension PhoneticBaseSyllable {
    
    public static func prefix(byte: UInt8) -> PhoneticBaseSyllable {
        return .prefix(PhoneticBasePrefix(byte: byte))
    }
    
    public static func suffix(byte: UInt8) -> PhoneticBaseSyllable {
        return .suffix(PhoneticBaseSuffix(byte: byte))
    }
    
    public var byte: UInt8 {
        switch self {
        case .prefix(let prefix):
            return prefix.byte
        case .suffix(let suffix):
            return suffix.byte
        }
    }
    
}
