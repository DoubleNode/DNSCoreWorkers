//
//  WKRCoreKeychainCache.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSBlankWorkers
import DNSCore
import DNSError
import DNSProtocols
import Foundation
import Valet

open class WKRCoreKeychainCache: WKRBlankCache {
    public enum C {
        public static let valetId = "WKRCoreKeychainCache"
    }
    private lazy var myValet: Valet = {
        let valet = Valet.valet(with: Identifier(nonEmpty: C.valetId)!,
                                accessibility: .whenUnlocked)
        return valet
    }()

    // MARK: - Internal Work Methods
    override open func intDoDeleteObject(for id: String,
                                         with progress: DNSPTCLProgressBlock?,
                                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubVoid {
        let future = WKRPTCLCacheFutVoid { [weak self] promise in
            do {
                try self?.myValet.removeObject(forKey: id)
                promise(.success)
                _ = resultBlock?(.completed)
            } catch {
                let dnsError = DNSError.Cache
                    .deleteError(error: error, .coreWorkers(self!))
                DNSCore.reportError(dnsError)
                promise(.failure(dnsError))
                _ = resultBlock?(.error)
            }
        }
        guard let nextWorker = self.nextWorker else { return future.eraseToAnyPublisher() }
        return Publishers.Zip(future, nextWorker.doDeleteObject(for: id, with: progress))
            .map { _, _ in () }
            .eraseToAnyPublisher()
    }
    override open func intDoReadObject(for id: String,
                                       with progress: DNSPTCLProgressBlock?,
                                       then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        let future = WKRPTCLCacheFutAny { [weak self] promise in
            do {
                if try self?.myValet.containsObject(forKey: id) ?? false {
                    promise(.success(try self?.myValet.object(forKey: id) as Any))
                } else {
                    promise(.success(Data() as Any))
                }
                _ = resultBlock?(.completed)
            } catch {
                let dnsError = DNSError.Cache
                    .readError(error: error, .coreWorkers(self!))
                DNSCore.reportError(dnsError)
                promise(.failure(dnsError))
                _ = resultBlock?(.error)
            }
        }
        guard let nextWorker = self.nextWorker else { return future.eraseToAnyPublisher() }
        return future
            .catch({ _ in
                nextWorker.doReadObject(for: id, with: progress)
            })
            .eraseToAnyPublisher()
    }
    override open func intDoReadString(for id: String,
                                       with progress: DNSPTCLProgressBlock?,
                                       then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubString {
        let future = WKRPTCLCacheFutString { [weak self] promise in
            do {
                if try self?.myValet.containsObject(forKey: id) ?? false {
                    promise(.success(try self?.myValet.string(forKey: id) ?? ""))
                } else {
                    promise(.success(""))
                }
                _ = resultBlock?(.completed)
            } catch {
                let dnsError = DNSError.Cache
                    .readError(error: error, .coreWorkers(self!))
                DNSCore.reportError(dnsError)
                promise(.failure(dnsError))
                _ = resultBlock?(.error)
            }
        }
        guard let nextWorker = self.nextWorker else { return future.eraseToAnyPublisher() }
        return future
            .catch({ _ in
                nextWorker.doReadString(for: id, with: progress)
            })
            .eraseToAnyPublisher()
    }
    override open func intDoUpdate(object: Any,
                                   for id: String,
                                   with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        let future = WKRPTCLCacheFutAny { [weak self] promise in
            do {
                if let string = object as? String {
                    try self?.myValet.setString(string, forKey: id)
                } else if let data = object as? Data {
                    try self?.myValet.setObject(data, forKey: id)
                }
                promise(.success(object))
                _ = resultBlock?(.completed)
            } catch {
                let dnsError = DNSError.Cache
                    .readError(error: error, .coreWorkers(self!))
                DNSCore.reportError(dnsError)
                promise(.failure(dnsError))
                _ = resultBlock?(.error)
            }
        }
        guard let nextWorker = self.nextWorker else { return future.eraseToAnyPublisher() }
        return Publishers.Zip(future, nextWorker.doUpdate(object: object, for: id, with: progress))
            .map { _, _ in object }
            .eraseToAnyPublisher()
    }
}
