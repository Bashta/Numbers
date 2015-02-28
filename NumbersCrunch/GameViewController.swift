//
//  GameViewController.swift
//  NumbersCrunch
//
//  Created by Alb on 11/7/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController, GameSceneDelegate {
	// The gameScene draws the tiles and cookie sprites, and handles swipes.
	var gameScene: GameScene!
	
	//The menu scene draws the menu buttons
	var menuScene: MenuScene!
	
	// The level contains the tiles, the cookies, and most of the gameplay logic.
	// Needs to be ! because it's not set in init() but in viewDidLoad().
	var level: Level!
	
	var movesLeft = 0
	var score = 0
	
	@IBOutlet weak var targetLabel: UILabel!
	@IBOutlet weak var movesLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var gameOverPanel: UIImageView!
	@IBOutlet weak var shuffleButton: UIButton!
	
	var tapGestureRecognizer: UITapGestureRecognizer!
	
	lazy var backgroundMusic: AVAudioPlayer = {
		let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
		let player = AVAudioPlayer(contentsOfURL: url, error: nil)
		player.numberOfLoops = -1
		return player
  }()
	//MARK: -
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func shouldAutorotate() -> Bool {
		return true
	}
	
	override func supportedInterfaceOrientations() -> Int {
		return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
	}
	
	//MARK: -
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
			    loadPlayScene()
			    gameScene.gameSceneDelegate = self
			}
	
	func beginGame() {
		movesLeft = level.maximumMoves
		score = 0
		updateLabels()
		
		level.resetComboMultiplier()
		
		gameScene.animateBeginGame() {
			self.shuffleButton.hidden = false
		}
		
		shuffle()
	}
	
	func shuffle() {
		// Delete the old cookie sprites, but not the tiles.
		gameScene.removeAllCookieSprites()
		
		// Fill up the level with new cookies, and create sprites for them.
		let newCookies = level.shuffle()
		gameScene.addSpritesForCookies(newCookies)
	}
	
	// This is the swipe handler. MyScene invokes this function whenever it
	// detects that the player performs a swipe.
	func handleSwipe(swap: Swap) {
		// While cookies are being matched and new cookies fall down to fill up
		// the holes, we don't want the player to tap on anything.
		view.userInteractionEnabled = false
		
		if level.isPossibleSwap(swap) {
			level.performSwap(swap)
			gameScene.animateSwap(swap, completion: handleMatches)
		} else {
			gameScene.animateInvalidSwap(swap) {
				self.view.userInteractionEnabled = true
			}
		}
	}
	
	// This is the main loop that removes any matching cookies and fills up the
	// holes with new cookies. While this happens, the user cannot interact with
	// the app.
	func handleMatches() {
		// Detect if there are any matches left.
		let chains = level.removeMatches()
		
		// If there are no more matches, then the player gets to move again.
		if chains.count == 0 {
			beginNextTurn()
			return
		}
		
		// First, remove any matches...
		gameScene.animateMatchedCookies(chains) {
			
			// Add the new scores to the total.
			for chain in chains {
				self.score += chain.score
			}
			self.updateLabels()
			
			// ...then shift down any cookies that have a hole below them...
			let columns = self.level.fillHoles()
			self.gameScene.animateFallingCookies(columns) {
				
				// ...and finally, add new cookies at the top.
				let columns = self.level.topUpCookies()
				self.gameScene.animateNewCookies(columns) {
					
					// Keep repeating this cycle until there are no more matches.
					self.handleMatches()
				}
			}
		}
	}
	
	func beginNextTurn() {
		level.resetComboMultiplier()
		level.detectPossibleSwaps()
		view.userInteractionEnabled = true
		decrementMoves()
	}
	
	func updateLabels() {
		targetLabel.text = NSString(format: "%ld", level.targetScore)
		movesLabel.text = NSString(format: "%ld", movesLeft)
		scoreLabel.text = NSString(format: "%ld", score)
	}
	
	func decrementMoves() {
		--movesLeft
		updateLabels()
		
		if score >= level.targetScore {
			gameOverPanel.image = UIImage(named: "LevelComplete")
			showGameOver()
		} else if movesLeft == 0 {
			gameOverPanel.image = UIImage(named: "GameOver")
			showGameOver()
		}
	}
	
	func showGameOver() {
		gameOverPanel.hidden = false
		gameScene.userInteractionEnabled = false
		shuffleButton.hidden = true
		
		gameScene.animateGameOver() {
			self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
			self.view.addGestureRecognizer(self.tapGestureRecognizer)
		}
	}
	
	func hideGameOver() {
		if tapGestureRecognizer != nil {
		
			view.removeGestureRecognizer(tapGestureRecognizer)
		}
		tapGestureRecognizer = nil
		
		gameOverPanel.hidden = true
		gameScene.userInteractionEnabled = true
		
		beginGame()
	}
	
	@IBAction func shuffleButtonPressed(AnyObject) {
		shuffle()
		
		// Pressing the shuffle button costs a move.
		decrementMoves()
	}
	
	//MARK: Temporary prototyping
	
	func loadPlayScene() {
		
		// Configure the view.
		let gameSKView = view as SKView
		gameSKView.multipleTouchEnabled = false
		
		// Create and configure the gameScene.
		gameScene = GameScene(size: gameSKView.bounds.size)
		gameScene.scaleMode = .AspectFill
		
		// Load the level.
		level = Level(filename: "Level_0")
		gameScene.level = level
		gameScene.addTiles()
		gameScene.swipeHandler = handleSwipe;
		
		// Hide the game over panel from the screen.
		gameOverPanel.hidden = true
		shuffleButton.hidden = true
		
		// Present the gameScene.
		gameSKView.presentScene(gameScene)
		
		// Load and start background music.
		backgroundMusic.play()
		
		// Let's start the game!
		beginGame()

	}
	
	func loadMenuView() {
		//Configure the view
		let menuSKView = view as SKView
		menuSKView.multipleTouchEnabled = false
		
		//Create and configure the menuScene.
		menuScene = MenuScene(size: menuSKView.bounds.size)
		menuScene.scaleMode = .AspectFill
		
		//Present the menu scene
		menuSKView.presentScene(menuScene)
	}
	
	//MARK: GameSceneDelegate methods
	
	func GameOver() {

		loadMenuView()
	}
}











