//
//  FileSystem.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-04.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

struct FileSystem {
	static func readBootROM() -> Data? {
		return readFile(name: "dmg_boot", ext: "bin")
	}
	
	static func readROM(name: String) -> Data? {
		return readFile(name: name, ext: "gb")
	}
	
	private static func readFile(name: String, ext: String) -> Data? {
		guard
			let path = Bundle.main.path(forResource: name, ofType: ext),
			let data = FileManager().contents(atPath: path)
			else {
				return nil
		}
		return data
	}
}
