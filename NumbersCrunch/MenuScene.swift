//
//  MenuScene.swift
//  NumbersCrunch
//
//  Created by Alb on 11/26/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

import SpriteKit
import UIKit

class MenuScene: SKScene {
	
	let menuLayer = SKNode()
	
	let playButton  = SKSpriteNode(imageNamed: "Button")
	let levelButton = SKSpriteNode(imageNamed: "Button")
	let scoreButton = SKSpriteNode(imageNamed: "Button")
	let background  = SKSpriteNode(imageNamed: "Background")
	
	// MARK: Menu Setup
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder) is not used in this app")
	}
	
	override init(size:CGSize) {
		super.init(size: size)
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
		// Put an image on the background. Because the scene's anchorPoint is
		// (0.5, 0.5), the background image will always be centered on the screen.
		addChild(background)
		
		// Add a new node that is the container for all other layers on the playing
		// field. This gameLayer is also centered in the screen.
		addChild(menuLayer)
		
		//Find the middle of the screen from where to put the buttons.
		let middleOfTheFramePosition = CGPoint(
			x: CGRectGetMidX(self.frame),
			y: CGRectGetMidY(self.frame))
		
		//Set up the position, name and add the play button to the menu layer
		let playButtonPositionX = middleOfTheFramePosition.x
		let playButtonPositionY = middleOfTheFramePosition.y + playButton.size.height * 2
		playButton.position = CGPoint(x: playButtonPositionX, y: playButtonPositionY)
		playButton.name = "Play"
		addChild(playButton)
		
		//Set up the position, name and add the level button to the menu layer
		let levelButtonPositionX = middleOfTheFramePosition.x
		let levelButtonPositionY = middleOfTheFramePosition.y
		levelButton.position = CGPoint(x: levelButtonPositionX, y: levelButtonPositionY)
		levelButton.name = "Level"
		addChild(levelButton)

		//Set up the position, name and add the play button to the menu layer
		let scoreButtonPositionX = middleOfTheFramePosition.x
		let scoreButtonPositionY = middleOfTheFramePosition.y - playButton.size.height * 2
		scoreButton.position = CGPoint(x: scoreButtonPositionX, y: scoreButtonPositionY)
		scoreButton.name = "Score"
		addChild(scoreButton)
		
	}
	
	// MARK: Detecting Touches
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(menuLayer)
		let node = self.nodeAtPoint(location)
		
		if node.name == "Play" {
		
		}
		
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		
	}
	
	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		
	}
	
}
