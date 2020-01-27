//
//  GameViewController.swift
//  SkyRoads
//
//  Created by dharay mistry on 01/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
import CoreData

class GameViewController: UIViewController,SCNPhysicsContactDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var cameraNode:SCNNode!
    var ship:SCNNode!
    var timer = Timer()
    var gameTime: Double = 0
    var obstacle1: SCNNode!
    var scene: SCNScene!
    
    var hudNode: SCNNode!
    var labelNode: SKLabelNode!
    var interval1: Double=2
    var score: Int = 0
    var paused = false
    
    
    var highScoreClosure: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
        // scene.lightingEnvironment.intensity=0.9
        
        // retrieve the ship node
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        scene.physicsWorld.contactDelegate=self
        
        initialObs()
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a gesture recognizer
        let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeR.direction = .right
        scnView.addGestureRecognizer(swipeR)
        let swipeU=UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeU.direction = .up
        scnView.addGestureRecognizer(swipeU)
        let swipeL=UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeL.direction = .left
        scnView.addGestureRecognizer(swipeL)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        initHUD()
        updateHUD()
    }
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval1), target: self, selector: #selector(update4t(timer:)), userInfo: nil, repeats: true)
        if(paused){
            gameOverAlert(score: score, VC: self, message: "")
            
        }
        freeze(flag: false, VC: self)
    }
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    @objc func swiped(_ gestureRecognize: UISwipeGestureRecognizer){
        
        switch gestureRecognize.direction {
        case UISwipeGestureRecognizer.Direction.left :
            ship.runAction(SCNAction.moveBy(x: -12, y: 0, z: 0, duration: 0.2), completionHandler: {
                if self.ship.position.x < -13 && self.ship.position.y < 0.6 {
                    self.ship.runAction(SCNAction.moveBy(x: 0, y: -12, z: 0, duration: 0.2), completionHandler: nil)
                    print("game over")
                    DispatchQueue.main.async {
                        self.gameOver()
                    }
                    
                    
                }
            }
            )
            print(self.ship.position.y)
        case UISwipeGestureRecognizer.Direction.right :
            ship.runAction(SCNAction.moveBy(x: 12, y: 0, z: 0, duration: 0.2), completionHandler: {
                if self.ship.position.x > 13 && self.ship.position.y < 0.6 {
                    self.ship.runAction(SCNAction.moveBy(x: 0, y: -12, z: 0, duration: 0.2), completionHandler: nil)
                    print("game over")
                    self.gameOver()
                    
                }
            }
            )
            print(self.ship.position.y)
        case UISwipeGestureRecognizer.Direction.up :
            if ship.position.y < 0.6{
                let moveUp = SCNAction.moveBy(x: 0, y: 12, z: 0, duration: 0.5)
                moveUp.timingMode = SCNActionTimingMode.easeOut;
                let moveDown = SCNAction.moveBy(x: 0, y: -12, z: 0, duration: 0.5)
                moveDown.timingMode = SCNActionTimingMode.easeIn;
                let moveSequence = SCNAction.sequence([moveUp,moveDown])
                ship.runAction(moveSequence, completionHandler: nil)
            }
            print("up")
        case UISwipeGestureRecognizer.Direction.down :
            print("down")
        default:
            return
        }
        
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @objc func update4t(timer:Timer) -> Void {
        if !paused{
            gameTime += interval1
            let o4=obs(pos: SCNVector3(Int(arc4random_uniform(4))*6-12,3,-400), vel: SCNVector3(0,0,100))
            scene.rootNode.addChildNode(o4)
            updateHUD()}
        
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeB.name == "obstacle" && contact.nodeA.name == "ship"{
            print("game over",contact.nodeA.name!,contact.nodeB.name!)
            gameOver()
            //	contact.
        }
    }
    func initialObs(){
        
        
        let o1=obs(pos: SCNVector3(12,3,-100), vel: SCNVector3(0,0,80))
        scene.rootNode.addChildNode(o1)
        let o2=obs(pos: SCNVector3(-12,3,-200), vel: SCNVector3(0,0,90))
        scene.rootNode.addChildNode(o2)
        let o3=obs(pos: SCNVector3(0,3,-300), vel: SCNVector3(0,0,100))
        scene.rootNode.addChildNode(o3)
        
    }
    func obs(pos:SCNVector3,vel:SCNVector3)->SCNNode{
        
        var obstacle:SCNNode!
        let geometry = SCNBox(width: 10.0, height: 5.0, length: 5.0, chamferRadius: 0.2)
        obstacle = SCNNode( geometry : geometry)
        obstacle.physicsBody = SCNPhysicsBody.init(type: SCNPhysicsBodyType.dynamic, shape: nil)
        obstacle.physicsBody?.categoryBitMask=1
        obstacle.physicsBody?.collisionBitMask=1
        obstacle.physicsBody?.contactTestBitMask=1
        obstacle.name="obstacle"
        obstacle.physicsBody?.friction = 0
        obstacle.physicsBody?.rollingFriction = 0
        obstacle.position=pos
        obstacle.physicsBody?.velocity = vel
        
        return obstacle
        
    }
    func initHUD() {
        
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 48
        labelNode.position.y = 50
        labelNode.position.x = 250
        
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 5, height: 1)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        hudNode = SCNNode(geometry: plane)
        hudNode.name = "HUD"
        hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
        hudNode.position = SCNVector3(x: 0.0, y: 40.0, z: 35.0)
        scene.rootNode.addChildNode(hudNode)
    }
    func updateHUD() {
        score=Int(gameTime)/2
        labelNode.text = "score:\(score)"
        
    }
    func gameOver()  {
        var mes="your Score:\(score)"
        scene.isPaused=true
        paused=true
        
        for s in 0...4{
            if score > Const.highScores[s]{
                Const.highScores.remove(at: 4)
                Const.highScores.append(score)
                mes="your Score:\(score) \n New Highscore!"
                
//                storeScore(score: self.score, date: Date())
                
                break
            }
            
        }
        storeScore(score: self.score, date: Date())
        //		gameOverAlert(score: score, VC: self,message: mes)
        let alertController = UIAlertController(title: "Game Over!", message: mes, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Main Menu", style: .default) { (action) in self.dismiss(animated: true, completion: nil)}
        let highScoreAction = UIAlertAction(title: "High Scores", style: .default) { (action) in
            self.dismiss(animated: true, completion: {self.highScoreClosure()})
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(highScoreAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {}
        }
        
    }
}
