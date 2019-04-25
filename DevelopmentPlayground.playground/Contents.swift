import Foundation

private protocol Register {
	var high: UInt8 { get set }
	var low: UInt8 { get set }
}

struct Registers {
	var AF: UInt16
	var BC: UInt16
	var DE: UInt16
	var HL: UInt16
	var SP: UInt16
	var PC: UInt16
}

extension UInt16: Register {
	var high: UInt8 {
		get {
			return (UInt8(self & 0x00FF))
		}
		set {
			self = (UInt16(low) << 8) | UInt16(newValue)
		}
	}
	
	var low: UInt8 {
		get {
			return (UInt8(self >> 8))
		}
		set {
			self = (UInt16(newValue) << 8) | UInt16(high)
		}
	}
}

class CPU {
	var registers: Registers!
	
	init() {
		reset()
	}
	
	private func reset() {
		registers = Registers(AF: 0x0, BC: 0x00000010, DE: 0x00000001, HL: 0x00001111, SP: 0x00001111, PC: 0x00001111)
	}
}

let cpu = CPU()

cpu.registers.AF.high = 0x01
cpu.registers.AF.low = 0x02
cpu.registers.AF
