//
//  EventSourceParser.swift
//  EventSource
//
//  Created by Andres on 30/05/2019.
//  Copyright © 2019 inaka. All rights reserved.
//

import Foundation

class EventSourceParser {
    
    private var buffer = NSMutableData()

    func append(data: Data) -> [Event] {
        buffer.append(data)
        
        return extractEventsFromBuffer().map { eventString in
            return Event.parseEvent(eventString)
        }
    }
    
}

extension EventSourceParser {

    private func extractEventsFromBuffer() -> [String] {
        var events = [String]()
        var searchRange =  NSRange(location: 0, length: buffer.length)
        
        while let foundRange = searchFirstEventDelimiter(in: searchRange) {
            let dataChunk = buffer.subdata(with: NSRange(location: searchRange.location, length: foundRange.location - searchRange.location))

            if let text = String(bytes: dataChunk, encoding: .utf8) {
                events.append(text)
            }

            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = buffer.length - searchRange.location
        }

        buffer.replaceBytes(in: NSRange(location: 0, length: searchRange.location), withBytes: nil, length: 0)

        return events
    }

    private func searchFirstEventDelimiter(in range: NSRange) -> NSRange? {
        let delimiter = "\n\n".data(using: .utf8)!

        let foundRange = buffer.range(of: delimiter, in: range)

        if foundRange.location != NSNotFound {
            return foundRange
        }
        
        return nil
    }
    
}
