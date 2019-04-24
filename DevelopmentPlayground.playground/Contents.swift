import Foundation

private protocol Register {
	func high() -> UInt8
	func low() -> UInt8
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
	func high() -> UInt8 {
		return (UInt8(self & 0xFF))
	}
	
	func low() -> UInt8 {
		return (UInt8(self & 0x00))
	}
}

var registers = Registers(AF: 0x00001111, BC: 0x0000010, DE: 0x00000001, HL: 0x00001111, SP: 0x00001111, PC: 0x00001111)


String(format: "%llX", registers.AF.high())
