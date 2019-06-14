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
	let MULTIPLIER = 1
	
	init(memory: VMMU, screen: CALayer) {
		self.memory = memory
		self.screen = screen
	}
	
	func render() {
//		self.screen.sublayers = []
//		let vram = self.memory.vram()
//		for (i, data) in vram.enumerated() {
//			let pixel = CALayer()
//			pixel.backgroundColor = data <= 0 ? UIColor.black.cgColor : UIColor.white.cgColor
//			let x = i % WIDTH
//			let y = (i - x) / WIDTH
//			pixel.frame = CGRect(x: x*MULTIPLIER, y: y*MULTIPLIER , width: MULTIPLIER, height: MULTIPLIER)
//			self.screen.addSublayer(pixel)
//		}
	}
}
