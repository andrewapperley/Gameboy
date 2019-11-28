//
//  Gameboy.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class Gameboy {
	var queue: DispatchQueue!
	var bp: UInt16 = 0
	var cartridge: Cartridge?
	let memory: MMU
	let cpu: CPU
	let ppu: PPU
	let apu: APU
	
	var debugger: Debugger? = nil
	
	init() {
		self.memory = MMU()
		self.cpu = CPU(memory: memory)
		self.ppu = PPU(memory: memory)
		self.apu = APU(memory: memory)
		self.setupQueue()
		cpu.cpuDelegate = self
	}
	
	func load(cartridge: Cartridge) {
		self.cartridge = cartridge
		memory.loadMemoryController(cartridge.memoryController)
		reset()
		cpu.start()
		queue.async {
			self.onTick()
		}
	}
	
	func reset() {
		self.memory.reset()
		self.cpu.reset()
	}
	
	func setupQueue() {
		self.queue = DispatchQueue(label: "Gameboy Dispatch Queue")
	}
	
	func onTick() {
		
		let start = Date().timeIntervalSince1970
		
		var count: Int = 0
		while count < cpu.clock.ticLoopCount {
			var delta = cpu.clock.mCounter
			self.cpu.tick()
			delta = cpu.clock.mCounter - delta
			self.ppu.render()
			count += Int(delta)
		}
		
		let elapsed = Date().timeIntervalSince1970 - start
		
		if cpu.running {
			let time = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * (cpu.clock.tic * Double(count) - elapsed))) / Double(NSEC_PER_SEC)
			queue.asyncAfter(deadline: time, execute: self.onTick)
		}
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
