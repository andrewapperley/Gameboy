//
//  Gameboy.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class Gameboy {
	let cpu = CPU()
	
	func load(cartridge: Cartridge) {
		cpu.start(cartridge: cartridge)
	}
}
