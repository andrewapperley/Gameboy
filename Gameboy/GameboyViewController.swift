//
//  GameboyViewController.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import UIKit

class GameboyViewController: UIViewController {

	let gameboy: Gameboy
	
	init() {
		self.gameboy = Gameboy()
		let cartridge = Cartridge(romName: "game")
		gameboy.load(cartridge: cartridge)
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
