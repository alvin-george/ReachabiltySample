//
//  UIappViewController.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import UIKit

class UIappViewController: UIViewController,AppManagerDelegate {
	var manager:AppManager = AppManager.sharedInstance

	override func viewDidLoad() {
		super.viewDidLoad()
		manager.delegate = self
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func reachabilityStatusChangeHandler(reachability: Reachability) {
		if reachability.isReachable() {
			print("isReachable")
		} else {
			print("notReachable")
		}
	}
}


