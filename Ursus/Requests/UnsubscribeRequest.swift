//
//  UnsubscribeRequest.swift
//  Alamofire
//
//  Created by Daniel Clelland on 7/06/20.
//

import Foundation

struct UnsubscribeRequest: Encodable {
    
    var action: String = "unsubscribe"
    var id: Int
    var subscriptionID: Int
    
    enum CodingKeys: String, CodingKey {
        case action
        case id
        case subscriptionID = "subscription"
    }
    
}
