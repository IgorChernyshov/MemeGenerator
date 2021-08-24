//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Igor Chernyshov on 21.08.2021.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var hintLabel: UILabel!

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMemeDidTap))
	}

	// MARK: - Actions
	@objc private func newMemeDidTap() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.delegate = self
		present(imagePickerController, animated: UIView.areAnimationsEnabled)
	}
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		dismiss(animated: UIView.areAnimationsEnabled)
		imageView.image = image
		hintLabel.isHidden = true
	}
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}
