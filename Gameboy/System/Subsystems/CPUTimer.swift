//
//  CPUTimer.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-04.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class CPUTimer {
	
	var mCounter: UInt = 0
    var baseCounter: UInt = 0
    var divCounter: UInt = 0
    var timaCounter: UInt = 0
	
    static let rate: Int = 4194304
	lazy var instrClock: Int = CPUTimer.rate/4
    lazy var tic: Double = 1.0/Double(instrClock)
	lazy var ticLoopCount: Int = instrClock/120
	
	let memory: MMU
	
	init(_ memory: MMU) {
		self.memory = memory
	}
	
	func updateClock(_ cycles: UInt) {
//		Read up on what to do with each timer update and if writing to memory is required
//		Also what to keep track of. Clock Cycles vs Machine Cycles
//		I believe its 1 Machine Cycle for every 4 Clock Cycles
		mCounter = mCounter &+ cycles
        baseCounter += cycles
        
        let baseBy4 = baseCounter / 4
        if(baseBy4 > 0) {
            baseCounter -= baseBy4 * 4
            divCounter += baseBy4
            
            if divCounter >= 16 { //DIV updates at 1/16*4
                var div = memory.readHalf(address: MemoryMap.DIV)
                div = div &+ UInt8(divCounter/16)
                memory.write(address: MemoryMap.DIV, data: div)
                divCounter %= 16
            }
            
            let timerControl = memory.readHalf(address: MemoryMap.TAC)
            if timerControl & 0x04 > 0 {
                timaCounter += baseBy4
                var increment = UInt8(0)
                switch  timerControl & 0x03 {
                case 0x00 where timaCounter >= 64: // M/64*4
                    increment = UInt8(timaCounter / 64)
                    timaCounter %= 64
                case 0x01:  // M/4
                    increment = UInt8(timaCounter)
                    timaCounter = 0
                case 0x02 where timaCounter >= 4: // M/4*4
                    increment = UInt8(timaCounter / 4)
                    timaCounter %= 4
                case 0x03 where timaCounter >= 16:// M/16*4
                    increment = UInt8(timaCounter / 16)
                    timaCounter %= 16
                default:
                    return
                }
                
                
                var tima = memory.readHalf(address: MemoryMap.TIMA)
				if tima > 0xFF - increment { memory.writeInterrupt(MemoryMap.IF.IF_TIMER) } //request timer interrupt
                tima = tima &+ increment
				memory.write(address: MemoryMap.TIMA, data: tima)
                memory.write(address: MemoryMap.TMA, data: tima)
            }
		}
	}
}
