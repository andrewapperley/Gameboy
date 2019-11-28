//
//  DebuggerView.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import UIKit

extension StateFlags {
	enum FlagMap: Int {
		case Z
		case N
		case H
		case C
	}
	func flagForRow(row: FlagMap) -> (name: String, value: Int) {
		switch row {
		case .Z:
			return ("Z", Z)
		case .N:
			return ("N", N)
		case .H:
			return ("H", H)
		case .C:
			return ("C", C)
		}
	}
}

extension StateRegisters {
	enum RegisterMap: Int {
		case A
		case B
		case C
		case D
		case E
		case F
		case H
		case L
		case SP
		case PC
	}
	func registerForRow(row: RegisterMap) -> (name: String, value: Int) {
		switch row {
		case .A:
			return ("A", Int(A))
		case .B:
			return ("B", Int(B))
		case .C:
			return ("C", Int(C))
		case .D:
			return ("D", Int(D))
		case .E:
			return ("E", Int(E))
		case .F:
			return ("F", Int(F))
		case .H:
			return ("H", Int(H))
		case .L:
			return ("L", Int(L))
		case .SP:
			return ("SP", Int(SP))
		case .PC:
			return ("PC", Int(PC))
		}
	}
}

private enum DebuggerViewSections: Int {
	case Registers
	case Flags
	case Rom
	case Memory

	static let RegistersKey = "Registers"
	static let FlagsKey = "Flags"
	static let RomKey = "Rom"
	static let MemoryKey = "Memory"
}

protocol DebuggerViewDelegate {
	func onNextFrameRequested()
}

class DebuggerView: UIView {
	let nextButton: UIButton
	let dataView: UITableView
	var state: CPUState? = nil
	var debuggerViewDelegate: DebuggerViewDelegate? = nil
	
	override init(frame: CGRect) {
		self.dataView = UITableView(frame: .zero)
		self.nextButton = UIButton(type: .roundedRect)
		super.init(frame: frame)
		setupNextButton()
		setupDataView()
		setupContraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupNextButton() {
		nextButton.setTitle("Next Frame", for: .normal)
		nextButton.setTitleColor(.white, for: .normal)
		nextButton.setTitleColor(.lightGray, for: .selected)
		nextButton.addTarget(self, action: #selector(onNextFrameRequested), for: .touchUpInside)
		self.addSubview(nextButton)
	}
	
	@objc func onNextFrameRequested() {
		self.debuggerViewDelegate?.onNextFrameRequested()
	}
	
	func setupDataView() {
		self.addSubview(dataView)
		dataView.dataSource = self
		dataView.register(UITableViewCell.self, forCellReuseIdentifier: DebuggerViewSections.RegistersKey)
		dataView.register(UITableViewCell.self, forCellReuseIdentifier: DebuggerViewSections.FlagsKey)
		dataView.register(UITableViewCell.self, forCellReuseIdentifier: DebuggerViewSections.MemoryKey)
		dataView.register(UITableViewCell.self, forCellReuseIdentifier: DebuggerViewSections.RomKey)
	}
	
	func setupContraints() {
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		dataView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			nextButton.topAnchor.constraint(equalTo: topAnchor),
			nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			dataView.topAnchor.constraint(equalTo: nextButton.bottomAnchor),
			dataView.leftAnchor.constraint(equalTo: leftAnchor),
			dataView.rightAnchor.constraint(equalTo: rightAnchor),
			dataView.bottomAnchor.constraint(equalTo: bottomAnchor),
			dataView.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
}

extension DebuggerView: Debugger {

	func onReceiveState(state: CPUState) {
		self.state = state
		dataView.reloadData()
	}
}

extension DebuggerView: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.state != nil ? 4 : 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let state = self.state else { return 0 }
		switch DebuggerViewSections(rawValue: section)! {
		case .Registers:
			return 10
		case .Flags:
			return 4
		case .Memory:
			return state.memory.memory.count
		case .Rom:
			return state.memory.rom?.count ?? 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch DebuggerViewSections(rawValue: section)! {
		case .Registers:
			return "Registers"
		case .Flags:
			return "Flags"
		case .Memory:
			return "Memory Map"
		case .Rom:
			return "Rom Data"
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		
		switch DebuggerViewSections(rawValue: indexPath.section)! {
			case .Registers:
				cell = tableView.dequeueReusableCell(withIdentifier: DebuggerViewSections.RegistersKey, for: indexPath)
				let register = self.state!.registers.registerForRow(row: StateRegisters.RegisterMap(rawValue: indexPath.row)!)
				cell.textLabel?.text = "\(register.name): 0x\(String(register.value, radix: 16, uppercase: true))"
			case .Flags:
				cell = tableView.dequeueReusableCell(withIdentifier: DebuggerViewSections.FlagsKey, for: indexPath)
				let flag = self.state!.registers.flags.flagForRow(row: StateFlags.FlagMap(rawValue: indexPath.row)!)
				cell.textLabel?.text = "\(flag.name): 0x\(String(flag.value, radix: 16, uppercase: true))"
			case .Memory:
				cell = tableView.dequeueReusableCell(withIdentifier: DebuggerViewSections.MemoryKey, for: indexPath)
				cell.textLabel?.text = "0x\(String(indexPath.row, radix: 16, uppercase: true)): 0x\(String(self.state!.memory.memory[Int(indexPath.row)], radix: 16, uppercase: true))"
			case .Rom:
				cell = tableView.dequeueReusableCell(withIdentifier: DebuggerViewSections.RomKey, for: indexPath)
				cell.textLabel?.text = "0x\(String(indexPath.row, radix: 16, uppercase: true)): 0x\(String(self.state!.memory.rom![Int(indexPath.row)], radix: 16, uppercase: true))"
		}
		return cell
	}
}
