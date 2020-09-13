//
//  MediaView.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 13.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit


class MediaView: UIView {
	private var imageView: UIImageView
	private var loaderView: UIActivityIndicatorView
	private var emptyView: UIView
	
	enum State {
		case loading
		case image(_ image: UIImage)
		case empty
	}
	
	var state: State = .empty {
		willSet {
			emptyView.isHidden = true
			loaderView.isHidden = true
			loaderView.stopAnimating()
			imageView.isHidden = true
		}
		didSet {
			switch state {
			case .loading:
				loaderView.isHidden = false
				loaderView.startAnimating()
			case .image(let image):
				imageView.isHidden = false
				imageView.image = image
			case .empty:
				emptyView.isHidden = false
			}
		}
	}
	
	init() {
		emptyView = UIView()
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 4
		imageView.layer.masksToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		loaderView = UIActivityIndicatorView()
		loaderView.translatesAutoresizingMaskIntoConstraints = false

		super.init(frame: .zero)

		addSubview(emptyView)
		addSubview(imageView)
		addSubview(loaderView)
		
		state = .empty
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateConstraints() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: self.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 100),
		])
		
		NSLayoutConstraint.activate([
			loaderView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			loaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
			])
		
		super.updateConstraints()

	}
	
	override class var requiresConstraintBasedLayout: Bool {
		return true
	}
    
}
