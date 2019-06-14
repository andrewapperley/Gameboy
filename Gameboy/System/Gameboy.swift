//
//  Gameboy.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
import QuartzCore

class Gameboy {
	var ticker: CADisplayLink!
	
	let memory: MMU
	let cpu: CPU
	let ppu: PPU
	
	var debugger: Debugger? = nil
	
	init(screen: CALayer) {
		self.memory = MMU()
		self.cpu = CPU(memory: memory)
		self.ppu = PPU(memory: memory, screen: screen)
		self.setupDisplayLink()
		cpu.cpuDelegate = self
	}
	
	func load(cartridge: Cartridge) {
		reset()
		cpu.start(cartridge: cartridge)
	}
	
	func reset() {
		self.memory.reset()
		self.cpu.reset()
	}
	
	func setupDisplayLink() {
		self.ticker = CADisplayLink(target: self, selector: #selector(onTick))
		self.ticker.add(to: RunLoop.current, forMode: .common)
	}
	
	@objc func onTick() {
		self.cpu.tick()
		self.ppu.render()
	}
}

extension Gameboy: CPUDelegate {
	func onCompletedFrame() {
		self.debugger?.onReceiveState(state: cpu.pause())
	}
	
	func nextFrame() {
		self.cpu.resume()
	}
}
