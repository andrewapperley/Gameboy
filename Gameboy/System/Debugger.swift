//
//  Debugger.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol Debugger {
	func onReceiveState(state: CPUState)
}
