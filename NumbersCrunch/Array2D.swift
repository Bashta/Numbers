//
//  Array2D.swift
//  NumbersCrunch
//
//  Created by Alb on 11/7/14.
//  Copyright (c) 2014 01Logic. All rights reserved.
//

struct Array2D<T> {
	let columns: Int
	let rows: Int
	private var array: Array<T?>
	
	init(columns: Int, rows: Int) {
		
		self.columns = columns
		self.rows = rows
		array = Array<T?>(count: rows*columns, repeatedValue: nil)
	}
	
	subscript(column: Int, row: Int) -> T? {
		get {
			return array[row*columns + column]
		}
		set {
			array[row*columns + column] = newValue
		}
	}
}