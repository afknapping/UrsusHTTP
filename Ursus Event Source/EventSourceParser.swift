//
//  EventSourceParser.swift
//  EventSource
//
//  Created by Andres on 30/05/2019.
//  Copyright © 2019 inaka. All rights reserved.
//

import Foundation

class EventSourceParser {
    
    private static let delimiter: Data = "\n\n".data(using: .utf8)!
    
    private var buffer = Data()

    func append(data: Data) -> [Event] {
        buffer.append(data)
        
        return extractEventsFromBuffer().map { string in
            return Event.parseEvent(string)
        }
    }
    
}

extension EventSourceParser {

    private func extractEventsFromBuffer() -> [String] {
        var events = [String]()
        var searchRange: Range<Data.Index> = buffer.startIndex..<buffer.endIndex
        
        while let foundRange = buffer.range(of: EventSourceParser.delimiter, in: searchRange) {
            let dataChunk = buffer.subdata(in: searchRange.startIndex..<foundRange.endIndex)

            if let text = String(bytes: dataChunk, encoding: .utf8) {
                events.append(text)
            }

            searchRange = foundRange.endIndex..<buffer.endIndex
        }

        buffer.removeSubrange(buffer.startIndex..<searchRange.startIndex)

        return events
    }
    
}
