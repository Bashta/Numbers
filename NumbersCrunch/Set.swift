//
//  Set.swift
//  NumbersCrunch
//
//  Created by Alb on 11/7/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

// A set is a collection that allows each element to appear only once, and it
// does not store the elements in any particular order.
// As of Xcode 6 beta 2, Swift does not include a Set class. This is a simple
// implementation of a set, using a Dictionary as the actual storage mechanism.
struct Set<T: Hashable>: SequenceType, Printable {
	private var dictionary = Dictionary<T, Bool>()
	
	mutating func addElement(newElement: T) {
		dictionary[newElement] = true
	}
	
	mutating func removeElement(element: T) {
		dictionary[element] = nil
	}
	
	func containsElement(element: T) -> Bool {
		return dictionary[element] != nil
	}
	
	func allElements() -> [T] {
		return Array(dictionary.keys)
	}
	
	var count: Int {
		return dictionary.count
	}
	
	func unionSet(otherSet: Set<T>) -> Set<T> {
		var combined = Set<T>()
		
		for obj in dictionary.keys {
			combined.dictionary[obj] = true
		}
		
		for obj in otherSet.dictionary.keys {
			combined.dictionary[obj] = true
		}
		
		return combined
	}
	
	func generate() -> IndexingGenerator<Array<T>> {
		return allElements().generate()
	}
	
	var description: String {
		return dictionary.description
	}
}
