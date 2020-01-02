//
//  GameboyViewController.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import UIKit

class GameboyViewController: UIViewController {

	var gameboy: Gameboy!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .black
		self.gameboy = Gameboy()
		
		if (ProcessInfo.processInfo.environment["DEBUGGER"] != nil) {
			setupDebugger()
		}
		
		gameboy.load(cartridge: Cartridge(romName: "game"))
    }
	
	func setupDebugger() {
		let debuggingView = DebuggerView(frame: self.view.bounds)
		debuggingView.debuggerViewDelegate = self
		
		self.view.addSubview(debuggingView)
		
		debuggingView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			debuggingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
			debuggingView.leftAnchor.constraint(equalTo: view.leftAnchor),
			debuggingView.rightAnchor.constraint(equalTo: view.rightAnchor),
			debuggingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			debuggingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		self.gameboy.debugger = debuggingView
	}
}

extension GameboyViewController: DebuggerViewDelegate {
	func onNextFrameRequested() {
		self.gameboy.nextFrame()
	}
}
