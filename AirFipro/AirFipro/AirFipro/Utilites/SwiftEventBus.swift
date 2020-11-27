//
//  SwiftEventBus.swift
//  VMEnergy
//
//  Created by iexm01 on 01/11/17.
//  Copyright © 2017 iExemplar. All rights reserved.
//

import UIKit
import Foundation

@objc class SwiftEventBus: NSObject {

    struct Static {
        static let instance = SwiftEventBus()
        static let queue = DispatchQueue(label: "com.cesarferreira.SwiftEventBus", attributes: [])
    }
    
    struct NamedObserver {
        let observer: NSObjectProtocol
        let name: String
    }
    
    var cache = [UInt:[NamedObserver]]()
    
    
    ////////////////////////////////////
    // Publish
    ////////////////////////////////////
    
    @objc class func post(_ name: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil)
    }
    
    @objc class func post(_ name: String, sender: AnyObject?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender)
    }
    
    @objc class func post1(_ name: String, sender: NSObject?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender)
    }
    
    @objc class func post(_ name: String, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userInfo)
    }
    
    @objc class func post(_ name: String, sender: AnyObject?, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender, userInfo: userInfo)
    }
    
    @objc class func postToMainThread(_ name: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil)
        }
    }
    
    @objc class func postToMainThread(_ name: String, sender: AnyObject?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender)
        }
    }
    
    @objc class func postToMainThread1(_ name: String, sender: NSObject?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender)
        }
    }
    
    @objc class func postToMainThread(_ name: String, userInfo: [AnyHashable: Any]?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userInfo)
        }
    }
    
    @objc class func postToMainThread(_ name: String, sender: AnyObject?, userInfo: [AnyHashable: Any]?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: sender, userInfo: userInfo)
        }
    }
    
    
    
    ////////////////////////////////////
    // Subscribe
    ////////////////////////////////////
    
    @discardableResult
    @objc class func on(_ target: AnyObject, name: String, sender: AnyObject?, queue: OperationQueue?, handler: @escaping ((Notification!) -> Void)) -> NSObjectProtocol {
        let id = UInt(bitPattern: ObjectIdentifier(target))
        let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: sender, queue: queue, using: handler)
        let namedObserver = NamedObserver(observer: observer, name: name)
        
        Static.queue.sync {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers + [namedObserver]
            } else {
                Static.instance.cache[id] = [namedObserver]
            }
        }
        
        return observer
    }
    
    @discardableResult
    @objc class func onMainThread(_ target: AnyObject, name: String, handler: @escaping ((Notification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: OperationQueue.main, handler: handler)
    }
    
    @discardableResult
    @objc class func onMainThread(_ target: AnyObject, name: String, sender: AnyObject?, handler: @escaping ((Notification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: OperationQueue.main, handler: handler)
    }
    
    @discardableResult
    @objc class func onBackgroundThread(_ target: AnyObject, name: String, handler: @escaping ((Notification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: OperationQueue(), handler: handler)
    }
    
    @discardableResult
    @objc class func onBackgroundThread(_ target: AnyObject, name: String, sender: AnyObject?, handler: @escaping ((Notification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: OperationQueue(), handler: handler)
    }
    
    ////////////////////////////////////
    // Unregister
    ////////////////////////////////////
    
    @objc class func unregister(_ target: AnyObject) {
        let id = UInt(bitPattern: ObjectIdentifier(target))
        let center = NotificationCenter.default
        
        Static.queue.sync {
            if let namedObservers = Static.instance.cache.removeValue(forKey: id) {
                for namedObserver in namedObservers {
                    center.removeObserver(namedObserver.observer)
                }
            }
        }
    }
    
    @objc class func unregister(_ target: AnyObject, name: String) {
        let id = UInt(bitPattern: ObjectIdentifier(target))
        let center = NotificationCenter.default
        
        Static.queue.sync {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers.filter({ (namedObserver: NamedObserver) -> Bool in
                    if namedObserver.name == name {
                        center.removeObserver(namedObserver.observer)
                        return false
                    } else {
                        return true
                    }
                })
            }
        }
    }
}