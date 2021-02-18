//
//  ViewController.swift
//  Gameboy Mac
//
//  Created by Andrew Apperley on 2021-01-17.
//  Copyright © 2021 Andrew Apperley. All rights reserved.
//

import Cocoa

class GameboyViewController: NSViewController {
    let gameboy = Gameboy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameboy.load(cartridge: Cartridge(romName: "game"))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

