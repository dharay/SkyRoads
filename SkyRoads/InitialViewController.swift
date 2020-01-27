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
        playButton.isHidden = true
        slideAnimate(self.playButton)
        slideAnimate(self.highScoreButton, direction: .right)

    }

	@IBOutlet weak var labell: UILabel!
	
    @IBOutlet weak var highScoreButton: MainMenuButtons!
    @IBOutlet weak var playButton: MainMenuButtons!
    @IBAction func speedChange(_ sender: AnyObject) {
		Const.speed = Int((sender as! UISlider).value)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
		Const.cVC = self
		freeze(flag: false, VC: self)
       
	
	}
	@IBAction func highscore(_ sender: AnyObject) {
		let hVC = storyboard?.instantiateViewController(withIdentifier: "hs") as! TableViewController
		navigationController?.pushViewController(hVC, animated: true)
		
	}
    
	@IBAction func playy(_ sender: AnyObject) {
		let game = storyboard?.instantiateViewController(withIdentifier: "game") as? GameViewController
        game?.modalPresentationStyle = .fullScreen
        game?.highScoreClosure = {
            
            self.highscore(self.labell)
        }
		self.present(game!, animated: true, completion: nil)
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
    private func slideAnimate(_ view: UIView, direction: SlideDirection = .left) {
        let animation = CAKeyframeAnimation()
        let initialValue = direction == .left ? -200 : 200
        let midValue  = direction == .left ? 50 : -50
//        view.frame = view.frame.offsetBy(dx: CGFloat(integerLiteral: initialValue), dy: 0)
        view.isHidden = false
        animation.keyPath = "position.x"
        animation.values = [initialValue, midValue, 0]
//        animation.keyTimes = [0, 0.5, 0,5]
        animation.duration = 2
        animation.isAdditive = true
        animation.timingFunctions = Array.init(repeating: .init(name: CAMediaTimingFunctionName.easeInEaseOut), count: 3)
        //[.init(name: CAMediaTimingFunctionName.easeInEaseOut)]
        view.layer.add(animation, forKey: "move")
    }
    enum SlideDirection {
        case left
        case right
        
        func toggled() -> SlideDirection {
            if self == .left {
                return SlideDirection.right
            }
            return SlideDirection.left
        }
    }
}
