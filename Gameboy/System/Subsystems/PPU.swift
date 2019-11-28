//
//  PPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-14.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
import UIKit

class PPU {
	let memory: VMMU

	let WIDTH: CGFloat = 160
	let HEIGHT: CGFloat = 144
	
	init(memory: VMMU) {
		self.memory = memory
	}
	
	func render() {
		
	}
}
