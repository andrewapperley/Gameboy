//
//  Gameboy.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class Gameboy {
	let queue = DispatchQueue(label: "Gameboy Dispatch Queue")
	var bp: UInt16 = 0
	var cartridge: Cartridge?
	let mmu: MMU
	let cpu: CPU
	let ppu: PPU
	let apu: APU
		
	init() {
		self.mmu = MMU()
		self.cpu = CPU(memory: mmu)
		self.ppu = PPU(memory: mmu)
		self.apu = APU(memory: mmu)
	}
	
    func loadBios() {
        guard let bios = FileSystem.readBootROM() else {
            fatalError("Failed to load bios")
        }
        mmu.loadBios(Array<UInt8>(bios))
    }
    
	func load(cartridge: Cartridge) {
		self.cartridge = cartridge
        mmu.loadMemoryController(cartridge.memoryController)
		reset()
		cpu.start()
		queue.async {
			self.onTick()
		}
	}
	
	func reset() {
		self.mmu.reset()
		self.cpu.reset()
//        loadBios()
	}
	
	func onTick() {
		
		let start = Date().timeIntervalSince1970
		
		var count: Int = 0
		while count <= cpu.clock.ticLoopCount {
			var delta = cpu.clock.mCounter
			self.cpu.tick()
			delta = cpu.clock.mCounter - delta
			self.ppu.render(delta: delta)
			count += Int(delta)
		}
		let elapsed = Date().timeIntervalSince1970 - start
		if cpu.running {
			let time = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * (cpu.clock.tic * Double(count) - elapsed))) / Double(NSEC_PER_SEC)
			queue.asyncAfter(deadline: time, execute: self.onTick)
		}
	}
}
