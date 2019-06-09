import Foundation

var count: Int = 1
var A: UInt8 = 0b00010111
String(A, radix: 2)
var mask: Int = 1 * A.bitWidth - count

count &= mask


let res = (A >> count) | (A << (-count & mask))

String(res, radix: 2)
