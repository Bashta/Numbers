//
//  Cookie.swift
//  NumbersCrunch
//
//  Created by Alb on 11/7/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

import SpriteKit

class Cookie: Printable, Hashable {
	var column: Int
	var row: Int
	let cookieType: CookieType
	var sprite: SKSpriteNode?
	
	init(column: Int, row: Int, cookieType: CookieType) {
		self.column = column
		self.row = row
		self.cookieType = cookieType
	}
	
	var description: String {
		return "type:\(cookieType) square:(\(column),\(row))"
	}
	
	var hashValue: Int {
		return row*10 + column
	}
}

enum CookieType: Int, Printable {
	case Unknown = 0, One, Two, Three, Four, Five, Six
	
	var spriteName: String {
		let spriteNames = [
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six"]
		
		return spriteNames[rawValue - 1]
	}
	
	var highlightedSpriteName: String {
		return spriteName + "-Highlighted"
	}
	
	static func random() -> CookieType {
		return CookieType(rawValue: Int(arc4random_uniform(6)) + 1)!
	}
	
	var description: String {
		return spriteName
	}
}

func ==(lhs: Cookie, rhs: Cookie) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}