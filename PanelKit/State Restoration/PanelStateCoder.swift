//
//  PanelStateCoder.swift
//  PanelKit
//
//  Created by Louis D'hauwe on 10/11/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

public protocol PanelStateCoder {
	
	/// Unique id to identify a panel.
	/// Used when restoring the panel's state.
	///
	/// A panel's id should be the same across app launches
	/// to successfully restore its state.
	var panelId: Int { get }
	
}
