//
//  AssociatedObject.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 25/02/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

// From: https://medium.com/@ttikitu/swift-extensions-can-add-stored-properties-92db66bce6cd#.a3wql3oiw

func associatedObject<ValueType: AnyObject>(
	_ base: AnyObject,
	key: UnsafePointer<UInt8>,
	initialiser: () -> ValueType)
	-> ValueType {
		if let associated = objc_getAssociatedObject(base, key) as? ValueType {
			return associated
		}

		let associated = initialiser()
		objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
		return associated
}

func associateObject<ValueType: AnyObject>(
	_ base: AnyObject,
	key: UnsafePointer<UInt8>,
	value: ValueType) {
	objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}
