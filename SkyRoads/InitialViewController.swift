//
//  InitialViewController.swift
//  SkyRoads
//
//  Created by dharay mistry on 01/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//
import Foundation
import UIKit
import CoreData
//import FBSDKLoginKit


class InitialViewController: UIViewController,FBSDKLoginButtonDelegate{
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var loginB : FBSDKLoginButton!
	var loginOut : UIButton!
	let prefs = UserDefaults.standard
	var outflag = false
	var t : FBSDKAccessToken!
    override func viewDidLoad() {
		if prefs.value(forKey: "name") == nil{prefs.set("name", forKey: "name")}
		
        super.viewDidLoad()
		
		
		navigationItem.title="Main Menu"
		navigationController?.isNavigationBarHidden=false
		getScores()
		loginB = Netw().getLoginBut()
		loginB.delegate = self
		
		loginB.center.x = self.view.center.x
		loginB.center.y = self.view.center.y + 30
		self.view.addSubview(loginB)
		
    }
	
	
	
	@IBOutlet weak var labell: UILabel!
	
	
	
	
	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
		print("atLast")
		freeze(flag: false, VC: self)
		//print("returned",result,error)
					 //FBSession.activeSession().accessTokenData.accessToken
			if FBSDKAccessToken.current() != nil{print("mission accomplished")}
			else{print("no token")}
		
		
		if error == nil{
			print("over here,no error",result)
			Netw().getName()
			assignName()
			
			}
		else{print("login error",error)}
		//print(result.token.debugDescription)
		//labell.text = result.token.userID
		
		
	}
	@IBAction func speedChange(_ sender: AnyObject) {
		Const.speed = Int((sender as! UISlider).value)
		
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

	}
	func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
		freeze(flag: true, VC: self)
		if Reachability()?.isReachable == false{
			Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.noNet), userInfo: nil, repeats: false)
			freeze(flag: false, VC: self)
			return false
		}
		
		return true
	}
	override func viewDidAppear(_ animated: Bool) {
		Const.cVC = self
		freeze(flag: false, VC: self)
		if (FBSDKAccessToken.current() != nil) {
			print("logged innnnnnnnnnnnnnn")
			
		}
	}
	@IBAction func highscore(_ sender: AnyObject) {
		let hVC = storyboard?.instantiateViewController(withIdentifier: "hs") as! TableViewController
		navigationController?.pushViewController(hVC, animated: true)
		
	}
    
	@IBAction func playy(_ sender: AnyObject) {
		let game = storyboard?.instantiateViewController(withIdentifier: "game")
		self.present(game!, animated: true, completion: nil)
	}

	@IBAction func quit(_ sender: AnyObject) {
		exit(0)
	}
	func noNet(){
	Launch4NoNet(VC: self,todismiss: false)
	}
	func assignName()  {
		if Const.name == nil{
		
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignName), userInfo: nil, repeats: false)
		}
		else{
		labell.text=Const.name
		
		}
	}

}
