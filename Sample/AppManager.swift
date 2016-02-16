//
//  AppManager.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import UIKit
import Foundation

class AppManager: NSObject{
	var delegate:AppManagerDelegate? = nil
    private var _useClosures:Bool = false
    private var reachability: Reachability?
    private var _isReachability:Bool = false

    var isReachability:Bool {
        get {return _isReachability}
    }
    
    
    // Create a shared instance of AppManager
    final  class var sharedInstance : AppManager {
        struct Static {
            static var instance : AppManager?
        }
        if !(Static.instance != nil) {
            Static.instance = AppManager()
            
        }
        return Static.instance!
    }

    // Reachability Methods--------------------------------------------------------------------------------//
    func initRechabilityMonitor() {
        print("initialize rechability...")
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("Unable to create\nReachability with address:\n\(address)")
            return
        } catch {}
        if (_useClosures) {
            reachability?.whenReachable = { reachability in
                self.notifyReachability(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.notifyReachability(reachability)
            }
        } else {
            self.notifyReachability(reachability!)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("unable to start notifier")
            return
        }
        
        
    }
    
    private func notifyReachability(reachability:Reachability) {
        if reachability.isReachable() {
            self._isReachability = true
        } else {
            self._isReachability = false
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
    }
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        dispatch_async(dispatch_get_main_queue()) {
			self.delegate?.reachabilityStatusChangeHandler(reachability)

        }
    }
    deinit {
        reachability?.stopNotifier()
        if (!_useClosures) {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        }
    }
}
