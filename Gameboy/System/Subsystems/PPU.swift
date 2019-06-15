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
	
	func render() { // Quick and dirty way of rendering pixels. This is obviously super wrong but I wanted to see what would happen. I don't actually want to render the vram as if its a pixelBuffer. I should have read more documentation ;)
		let vram = self.memory.vram()
		UIGraphicsBeginImageContextWithOptions(CGSize(width: WIDTH, height: HEIGHT), true, 1.5)
		guard let context = UIGraphicsGetCurrentContext() else {return}
		for (i, data) in vram.enumerated() {
			let colour: UIColor = data <= 0 ? .black : .white
			let x = i % Int(WIDTH)
			let y = (i - x) / Int(WIDTH)
			let rect = CGRect(x: x, y: y , width: 1, height: 1)
			context.setFillColor(colour.cgColor)
			context.fill(rect)
		}
		(self.screen.subviews[0] as! UIImageView).image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
}
