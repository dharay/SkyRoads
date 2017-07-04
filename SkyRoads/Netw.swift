//
//  Netw.swift
//  SkyRoads
//
//  Created by dharay mistry on 05/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import UIKit

import CFNetwork


class Netw{

	func getLoginBut() -> FBSDKLoginButton {
		
		var myLoginButton = FBSDKLoginButton()
		//	myLoginButton.delegate = VC
		
		return myLoginButton
	}

 func share(VC:UIViewController){
	freeze(flag: true, VC: VC)
		let content = FBSDKShareLinkContent()
	content.contentURL = URL(string: "https://my.app.link")!
	
	let dialog = FBSDKShareDialog()
	dialog.fromViewController = VC
	dialog.shareContent = content
	dialog.mode = FBSDKShareDialogMode.shareSheet
	FBSDKShareDialog.show(from: VC, with: content, delegate: nil)
	//dialog.show()
	
	}
	func getName()  {
		
		FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"]).start(completionHandler: { (a:FBSDKGraphRequestConnection?, res:Any?, e:Error?) in
			if e == nil {
				print("fetched user:\(res)",a)
				let strFirstName: String = ((res as! [String:Any])["name"] as? String)!
				print(strFirstName)
				Const.name = strFirstName
				}
			}
		
		)
	}
}
