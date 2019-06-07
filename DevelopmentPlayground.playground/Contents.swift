import Foundation
extension UInt8 {
	
	func bit(at index: Int) -> Int {
		return Int(bitPattern: UInt(bitPattern: Int(self) & (0x1 << index)) >> index)
	}
	
	func bits() -> [Int] {
		var bits: [Int] = Array<Int>(repeating: 0x0, count: bitWidth)
		for i in 0..<bitWidth {
			bits[i] = bit(at: i)
		}
		return bits.reversed()
	}
	
	mutating func setBit(at index: Int, to: UInt8) {
		self = UInt8(self & ~(0x1 << index) | (to << index))
	}
	
	func isSet(_ bit: Int) -> Bool {
		return bit == 1 ? true : false
	}
}

var A: UInt8 = 0b10010010
var n: UInt8 = 0b10010010
var r: UInt8 = A ^ n

r.bits()
