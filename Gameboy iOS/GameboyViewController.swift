//
//  GameboyViewController.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import UIKit

class GameboyViewController: UIViewController {

	let gameboy = Gameboy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .black
		
        setupRenderer()
		
        gameboy.load(cartridge: Cartridge(romName: "game"))
    }
}
