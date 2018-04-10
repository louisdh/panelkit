//
//  PanelPinnedMetadata.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 04/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

public struct PanelPinnedMetadata: Codable, Hashable {
	public var side: PanelPinSide
	public var index: Int
	let date = Date()
	
	public init(side: PanelPinSide, index: Int) {
		self.side = side
		self.index = index
	}
}
