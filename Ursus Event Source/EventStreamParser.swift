//
//  EventStreamParser.swift
//  EventSource
//
//  Created by Andres on 30/05/2019.
//  Copyright © 2019 inaka. All rights reserved.
//

import Foundation

class EventStreamParser {

    private static let validNewlineCharacters = ["\r\n", "\n", "\r"]
    
    private let dataBuffer = NSMutableData()

    var currentBuffer: String? {
        return NSString(data: dataBuffer as Data, encoding: String.Encoding.utf8.rawValue) as String?
    }

    func append(data: Data?) -> [Event] {
        guard let data = data else { return [] }
        dataBuffer.append(data)

        let events = extractEventsFromBuffer().compactMap { eventString in
            return Event(eventString: eventString, newLineCharacters: EventStreamParser.validNewlineCharacters)
        }

        return events
    }
    
}

extension EventStreamParser {

    private func extractEventsFromBuffer() -> [String] {
        var events = [String]()
        var searchRange =  NSRange(location: 0, length: dataBuffer.length)
        
        while let foundRange = searchFirstEventDelimiter(in: searchRange) {
            let dataChunk = dataBuffer.subdata(with: NSRange(location: searchRange.location, length: foundRange.location - searchRange.location))

            if let text = String(bytes: dataChunk, encoding: .utf8) {
                events.append(text)
            }

            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = dataBuffer.length - searchRange.location
        }

        dataBuffer.replaceBytes(in: NSRange(location: 0, length: searchRange.location), withBytes: nil, length: 0)

        return events
    }

    private func searchFirstEventDelimiter(in range: NSRange) -> NSRange? {
        let delimiters = EventStreamParser.validNewlineCharacters.compactMap { "\($0)\($0)".data(using: .utf8) }

        for delimiter in delimiters {
            let foundRange = dataBuffer.range( of: delimiter, in: range)

            if foundRange.location != NSNotFound {
                return foundRange
            }
        }

        return nil
    }
    
}
