//
//  Constants.swift
//  SkyRoads
//
//  Created by dharay mistry on 03/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import UIKit


struct Const {
	static var highScores:[Int]=[]
	static var CDscores:[HS]=[]
	static var CDcount:Int!
    static var actView = UIActivityIndicatorView(style: .gray)
	static var speed:Int = 0
	static var cVC:UIViewController!
	static var name:String!
}




func Launch4NoNet(VC:UIViewController,todismiss:Bool){
	let alertController = UIAlertController(title: "Something went wrong!", message: "no internet", preferredStyle: .alert)
	
	let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
		if todismiss{
			print("dismiss")
			VC.dismiss(animated: true, completion: nil)
		}
	}
	alertController.addAction(OKAction)
	
	VC.present(alertController, animated: true) {}
	
}
func LaunchAlert(s:String,VC:UIViewController){
	
	
	let alertController = UIAlertController(title: "Something went wrong!", message: s, preferredStyle: .alert)
	
	let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
	alertController.addAction(OKAction)
	VC.present(alertController, animated: true) {}
	
	
}
func gameOverAlert(score:Int,VC:UIViewController,message:String){

	let alertController = UIAlertController(title: "Game Over!", message: message, preferredStyle: .alert)
	
	let OKAction = UIAlertAction(title: "MainMenu", style: .default) { (action) in VC.dismiss(animated: true, completion: nil)}
	alertController.addAction(OKAction)
	let fb = UIAlertAction(title: "share on FB", style: .default) { (action) in
		if(Reachability()?.isReachable)!{
			//freeze(flag: true, VC: VC)
		
			//VC.dismiss(animated: true,completion: nil)
		}
		else{
		Launch4NoNet(VC: VC,todismiss: true)
		}
	
	}
	alertController.addAction(fb)
	VC.present(alertController, animated: true) {}


}
func freeze(flag:Bool,VC:UIViewController){
	
	
		
		if flag
		{

			//UIApplication.shared.beginIgnoringInteractionEvents()
			Const.actView.center=VC.view!.center
			let currentview = VC.view!
			currentview.addSubview(Const.actView)
			Const.actView.startAnimating()
		}
		else{
			print("end load")
			//UIApplication.shared.endIgnoringInteractionEvents()
			Const.actView.stopAnimating()
		}
		
	
	
}
