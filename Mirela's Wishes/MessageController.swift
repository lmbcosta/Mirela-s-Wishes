//
//  MessageController.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 09/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation

struct Message {
    private var _text: String!
    private var _sendTo: String!
    
    var text: String {
        set {
            if (_text == nil) {_text = newValue}
        }
        
        get { return _text}
    }
    
    var sendTo: String {
        set {
            if _sendTo == nil {_sendTo = newValue}
        }
        get {return  _sendTo}
    }
}

class MessageController {
    
    // Clock API
    private let clockworkAPIURL = "https://api.clockworksms.com/http/send.aspx?"
    // API key
    private let clockworkAPIkey = "your_own_API_key"
    
    func sendSMS(msg: Message) -> String {
        var urlSring = clockworkAPIURL + "key=" + clockworkAPIkey +
            "&to=" + msg.sendTo + "&content=" + msg.text
        urlSring = urlSring.replacingOccurrences(of: " ", with: "+")
        var result = "Error"
        
        // Create a URL
        if let clockworkSMSURL = URL(string: urlSring),
            let responseData = try? Data(contentsOf: clockworkSMSURL) {
            result = String(data: responseData, encoding: String.Encoding.utf8)!
        }
        print("the result is: \(result)")
        return result
    }
}
