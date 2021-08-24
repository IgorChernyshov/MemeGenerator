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

	// MARK: - Properties
	private var sourceImage: UIImage? {
		didSet {
			hintLabel.isHidden = sourceImage != nil
			renderMeme()
		}
	}
	private var topText: String? {
		didSet {
//			renderMeme()
		}
	}
	private var bottomText: String? {
		didSet {
//			renderMeme()
		}
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap))
	}

	// MARK: - Actions
	@objc private func addButtonDidTap() {
		let actionSheet = UIAlertController(title: "Add item", message: "Select an item to add", preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Image", style: .default) { [weak self] _ in
			self?.addImageDidTap()
		})
		actionSheet.addAction(UIAlertAction(title: "Top text", style: .default) { [weak self] _ in
			self?.showInputTextForm(isTopText: true)
		})
		actionSheet.addAction(UIAlertAction(title: "Bottom text", style: .default) { [weak self] _ in
			self?.showInputTextForm(isTopText: false)
		})
		actionSheet.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
			self?.topText = nil
			self?.bottomText = nil
			self?.sourceImage = nil
		})
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(actionSheet, animated: UIView.areAnimationsEnabled)
	}

	private func addImageDidTap() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.delegate = self
		present(imagePickerController, animated: UIView.areAnimationsEnabled)
	}

	private func showInputTextForm(isTopText: Bool) {
		let textInputController = UIAlertController(title: "Insert text for \(isTopText ? "top" : "bottom")", message: nil, preferredStyle: .alert)
		textInputController.addTextField()
		textInputController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
			let text = textInputController.textFields?.first?.text
			if isTopText {
				self?.topText = text
			} else {
				self?.bottomText = text
			}
		})
		present(textInputController, animated: UIView.areAnimationsEnabled)
	}

	// MARK: - Meme Rendering
	private func renderMeme() {
		// Stub.
		// TODO: - True rendering
		imageView.image = sourceImage
	}
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		dismiss(animated: UIView.areAnimationsEnabled)
		sourceImage = image
	}
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}
