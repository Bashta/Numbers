//
//  Swap.swift
//  NumbersCrunch
//
//  Created by Alb on 11/13/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

import Foundation

struct Swap: Printable, Hashable {
	let cookieA: Cookie
	let cookieB: Cookie
 
	init(cookieA: Cookie, cookieB: Cookie) {
		self.cookieA = cookieA
		self.cookieB = cookieB
	}
 
	var description: String {
		return "swap \(cookieA) with \(cookieB)"
	}
	
	var hashValue: Int {
		
		return cookieA.hashValue ^ cookieB.hashValue
	}
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
	return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
		(lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}