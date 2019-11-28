import Foundation

extension UInt8 {
	mutating func setBit(at index: Int, to: UInt8) {
		self = UInt8(self & ~(0x1 << index) | (to << index))
	}
}

var F: UInt8 = 0b10000000
F.setBit(at: 7, to: 0)
