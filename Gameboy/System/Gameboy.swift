//
//  Gameboy.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class Gameboy: CPUDelegate {
	let cpu = CPU()
	var debugger: Debugger? = nil
	
	init() {
		cpu.cpuDelegate = self
	}
	
	func nextFrame() {
		self.cpu.resume()
	}
	
	func onCompletedFrame() {
		self.debugger?.onReceiveState(state: cpu.pause())
	}
	
	func load(cartridge: Cartridge) {
		cpu.start(cartridge: cartridge)
	}
}
