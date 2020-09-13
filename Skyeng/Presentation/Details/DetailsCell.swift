//
//  DetailsCell.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 13.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
	
	@IBOutlet var cellTitle: UILabel!
	@IBOutlet var mediaView: MediaView!
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		cellTitle = UILabel()
		cellTitle.numberOfLines = 3
		cellTitle.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(cellTitle)
		
		mediaView = MediaView()
		mediaView.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(mediaView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setTitle(_ text: String) {
		cellTitle.text = text
	}
	
	public func setMediaViewState(_ state: MediaView.State) {
		mediaView.state = state
	}
	
	override func updateConstraints() {
		mediaView.layout {
			$0.top == contentView.topAnchor + 8
			$0.leading == contentView.leadingAnchor + 8
			$0.bottom == contentView.bottomAnchor - 8
		}
		mediaView.widthAnchor.constraint(equalTo: mediaView.heightAnchor, multiplier: 1).isActive = true
		
		cellTitle.layout {
			$0.top == contentView.topAnchor + 8
			$0.leading == mediaView.trailingAnchor + 8
			$0.trailing == contentView.trailingAnchor - 8
		}
		
		super.updateConstraints()
	}
	
	override class var requiresConstraintBasedLayout: Bool {
		return true
	}
    
}
