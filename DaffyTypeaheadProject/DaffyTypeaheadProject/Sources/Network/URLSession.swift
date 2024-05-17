//
//  URLSession.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation

class NetworkURLSession: NSObject, APIClient {
    public var session: URLSessionProtocol!
    var task: URLSessionDataTaskProtocol?
    static var sharedSession = SharedSession()
    
    public init(configuration: URLSessionConfiguration) {
        super.init()
        self.session = NetworkURLSession.sharedSession.instance
    }
}

class SharedSession: NSObject {
    public var instance: URLSession!
    override init() {
        super.init()
        instance = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
}

extension SharedSession: URLSessionDelegate, URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential: URLCredential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
        else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
