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
	let screen: UIView

	let WIDTH: CGFloat = 160
	let HEIGHT: CGFloat = 144
	
	init(memory: VMMU, screen: UIView) {
		self.memory = memory
		self.screen = screen
		self.screen.addSubview(UIImageView(frame: CGRect(x: (screen.bounds.width - WIDTH)/2, y: 50, width: WIDTH, height: HEIGHT)))
	}
	
	func render() {
		
	}
}
