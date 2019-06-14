//
//  PPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-14.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class PPU {
	let memory: VMMU
	let screen: CALayer

	let WIDTH = 160
	let HEIGHT = 144
	
	init(memory: VMMU, screen: CALayer) {
		self.memory = memory
		self.screen = screen
	}
	
	func render() { // Quick and dirty way of rendering pixels. This is obviously super wrong but I wanted to see what would happen. I don't actually want to render the vram as if its a pixelBuffer. I should have read more documentation ;)
		self.screen.sublayers = []
		let vram = self.memory.vram()
		for (i, data) in vram.enumerated() {
//			let pixel = CALayer()
//			pixel.backgroundColor = data <= 0 ? UIColor.black.cgColor : UIColor.white.cgColor
//			let x = i % WIDTH
//			let y = (i - x) / WIDTH
//			pixel.frame = CGRect(x: x, y: y , width: 1, height: 1)
//			self.screen.addSublayer(pixel)
		}
	}
}
