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


class InitialViewController: UIViewController{
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	var loginOut : UIButton!
	let prefs = UserDefaults.standard
	var outflag = false

    override func viewDidLoad() {
		if prefs.value(forKey: "name") == nil{prefs.set("name", forKey: "name")}
		
        super.viewDidLoad()
		
		
		navigationItem.title="Main Menu"
		navigationController?.isNavigationBarHidden=false
		getScores()

		
    }
	
	
	
	@IBOutlet weak var labell: UILabel!
	
	
	
	
	
	@IBAction func speedChange(_ sender: AnyObject) {
		Const.speed = Int((sender as! UISlider).value)
		
	}
	

	override func viewDidAppear(_ animated: Bool) {
		Const.cVC = self
		freeze(flag: false, VC: self)
	
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
    @objc func noNet(){
	Launch4NoNet(VC: self,todismiss: false)
	}
    @objc func assignName()  {
		if Const.name == nil{
		
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignName), userInfo: nil, repeats: false)
		}
		else{
		labell.text=Const.name
		
		}
	}

}
