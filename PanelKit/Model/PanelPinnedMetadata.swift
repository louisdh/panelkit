//
//  PanelPinnedMetadata.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 04/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

struct PanelPinnedMetadata: Codable {
	var side: PanelPinSide
	var index: Int
	let date = Date()
}

extension PanelPinnedMetadata: Hashable {
	
	static func ==(lhs: PanelPinnedMetadata, rhs: PanelPinnedMetadata) -> Bool {
		return lhs.side == rhs.side && lhs.index == rhs.index && lhs.date == rhs.date
	}
	
	var hashValue: Int {
		return date.hashValue
	}

}
