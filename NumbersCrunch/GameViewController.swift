//
//  GameViewController.swift
//  NumbersCrunch
//
//  Created by Alb on 11/7/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
	
	var level: Level!
	var scene: GameScene!
	
	var movesLeft = 0
	var score = 0
 
	@IBOutlet weak var targetLabel: UILabel!
	@IBOutlet weak var movesLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	
	func updateLabels() {
  
		
		targetLabel.text = NSString(format: "%ld", level.targetScore)
	     movesLabel.text = NSString(format: "%ld", movesLeft)
          scoreLabel.text = NSString(format: "%ld", score)
	}
 
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
 
	override func shouldAutorotate() -> Bool {
		return true
	}
 
	override func supportedInterfaceOrientations() -> Int {
		return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
	}
 
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Configure the view.
		let skView = view as SKView
		skView.multipleTouchEnabled = false
		
		// Create and configure the scene.
		scene = GameScene(size: skView.bounds.size)
		scene.scaleMode = .AspectFill
		
		level = Level(filename: "Level_0")
		scene.level = level
		scene.addTiles()
		scene.swipeHandler = handleSwipe
		// Present the scene.
		skView.presentScene(scene)
		
		beginGame()
		
	}
	
	func beginGame() {
		
		movesLeft = level.maximumMoves
		score = 0
		updateLabels()
		
	     shuffle()
	}
 
	func shuffle() {
     let newCookies = level.shuffle()
	 scene.addSpritesForCookies(newCookies)
	}
	
	func handleSwipe(swap: Swap) {
  view.userInteractionEnabled = false
		
  if level.isPossibleSwap(swap)
{
	level.performSwap(swap)
	scene.animateSwap(swap, completion: handleMatches)
	self.view.userInteractionEnabled = true
	
	
} else {
	scene.animateInvalidSwap(swap){
		self.view.userInteractionEnabled = true
	}
	}
	}
	
	func handleMatches() {
		
		let chains = level.removeMatches()
		if chains.count == 0 {
			beginNextTurn()
			return
		}
  scene.animateMatchedCookies(chains) {
	let columns = self.level.fillHoles()
	self.scene.animateFallingCookies(columns) {
		let columns = self.level.topUpCookies()
		self.scene.animateNewCookies(columns) {
			self.handleMatches()
		}
	}
  }
	}
	
	func beginNextTurn() {
		level.detectPossibleSwaps()
	     view.userInteractionEnabled = true
	}
	
	
	
}//class END