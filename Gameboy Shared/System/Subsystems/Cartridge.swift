//
//  Cartridge.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-03.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

enum DeviceType: Int {
	case DMG = 0x0
}

enum CartridgeType: Int {
	case ROM = 0x0
	case ROM_MBC1 = 0x1
	case ROM_MBC1_RAM = 0x2
	case ROM_MBC1_RAM_BATT = 0x3
	case ROM_MBC2 = 0x5
	case ROM_MBC2_BATTERY = 0x6
	case ROM_RAM = 0x8
	case ROM_RAM_BATTERY = 0x9
	case ROM_MMM01 = 0xB
	case ROM_MMM01_SRAM = 0xC
	case ROM_MMM01_SRAM_BATT = 0xD
	case ROM_MBC3_TIMER_BATT = 0xF
	case ROM_MBC3_TIMER_RAM_BATT = 0x10
	case ROM_MBC3 = 0x11
	case ROM_MBC3_RAM = 0x12
	case ROM_MBC3_RAM_BATT = 0x13
	case ROM_MBC5 = 0x19
	case ROM_MBC5_RAM = 0x1A
	case ROM_MBC5_RAM_BATT = 0x1B
	case ROM_MBC5_RUMBLE = 0x1C
	case ROM_MBC5_RUMBLE_SRAM = 0x1D
	case ROM_MBC5_RUMBLE_SRAM_BATT = 0x1E
	case POCKET_CAMERA = 0x1F
	case BANDAI_TAMA5_FE = 0xFD
	case HUDSON_HUC = 0xFE
	case HUDSON_HUC_1 = 0xFF
}

enum RomSize: Int {
	case kBit_256 = 0
	case kBit_512
	case MBit_1
	case MBit_2
	case MBit_4
	case MBit_8
	case MBit_16
	case MBit_9 = 0x52
	case MBit_10 = 0x53
	case MBit_12 = 0x54
}

enum RamSize: Int {
	case None = 0
	case kBit_16
	case kBit_64
	case kBit_256
	case MBit_1
}

enum DestinationCode: Int {
	case Japanese = 0
	case Non_Japanese
}

enum LicenseeCode: Int {
	case Check_0144_0145_for_Licensee_code = 0x33
	case Accolade = 0x79
	case Konami = 0xA4
}

enum CartridgeMemoryMap: Int {
	case TitleStart = 0x0134
	case TitleEnd = 0x0142
	case DeviceType = 0x0143
	case LicenseeCode = 0x0144
	case SGB = 0x0146
	case CartridgeType = 0x0147
	case RomSize = 0x0148
	case Ramize = 0x0149
	case DestinationCode = 0x014A
	case MaskROMVersion = 0x014B
	case HeaderCheck = 0x014D
	case GlobalCheck = 0x014E
}

struct Cartridge {
	let title: String
	let type: CartridgeType
	let deviceType: DeviceType
	let romSize: RomSize
	let ramSize: RamSize
	let maskROMVersion: Bool
	let destinationCode: DestinationCode
	let memoryController: MemoryController
	
	init(romName: String) {
		guard let data = FileSystem.readROM(name: romName) else {
			fatalError("Cartridge data failed to load")
		}
		let rom = Array<UInt8>(data)

		title = Cartridge.getTitle(from: rom)
		deviceType = Cartridge.getDeviceType(from: rom)
		type = Cartridge.getCartridgeType(from: rom)
		memoryController = Cartridge.getMemoryControllerType(from: type, with: rom)
		romSize = Cartridge.getRomSize(from: rom)
		ramSize = Cartridge.getRamSize(from: rom)
		destinationCode = .Non_Japanese
		maskROMVersion = true
	}
	
	private static func getTitle(from rom: [UInt8]) -> String {
		let data = rom[CartridgeMemoryMap.TitleStart.rawValue...CartridgeMemoryMap.TitleEnd.rawValue].filter { (byte) -> Bool in
			return byte != 0
		}
		return String(bytes: data, encoding: .utf8) ?? ""
	}
	
	private static func getDeviceType(from rom: [UInt8]) -> DeviceType {
		return DeviceType(rawValue: Int(rom[CartridgeMemoryMap.DeviceType.rawValue])) ?? DeviceType.DMG
	}
	
	private static func getCartridgeType(from rom: [UInt8]) -> CartridgeType {
		return CartridgeType(rawValue: Int(rom[CartridgeMemoryMap.CartridgeType.rawValue])) ?? CartridgeType.ROM
	}
	
	private static func getRomSize(from rom: [UInt8]) -> RomSize {
		return RomSize(rawValue: Int(rom[CartridgeMemoryMap.RomSize.rawValue])) ?? RomSize.kBit_256
	}
	
	private static func getRamSize(from rom: [UInt8]) -> RamSize {
		return RamSize(rawValue: Int(rom[CartridgeMemoryMap.Ramize.rawValue])) ?? RamSize.None
	}
	
	private static func getMemoryControllerType(from type: CartridgeType, with rom: [UInt8]) -> MemoryController {
		switch type {
		case .ROM:
			return MBC0(memory: rom)
		case .ROM_MBC1:
			return MBC1(memory: rom)
		case .ROM_MBC2:
			return MBC2(memory: rom)
		@unknown default:
			return MBC0(memory: rom)
		}
	}
}
