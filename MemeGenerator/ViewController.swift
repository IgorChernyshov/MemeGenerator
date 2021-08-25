//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Igor Chernyshov on 21.08.2021.
//

import UIKit
import CoreGraphics

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
			renderMeme()
		}
	}
	private var bottomText: String? {
		didSet {
			renderMeme()
		}
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Meme Generator"
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
		guard let image = sourceImage else {
			imageView.image = sourceImage
			return
		}

		let imageSize = imageView.bounds.size
		let renderer = UIGraphicsImageRenderer(size: imageSize)
		let memeImage = renderer.image { [weak self] context in
			image.draw(at: CGPoint(x: 0, y: 0))

			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center

			let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 24),
															 .foregroundColor: UIColor.label,
															 .backgroundColor: UIColor.systemBackground,
															 .paragraphStyle: paragraphStyle]

			let topString = self?.topText ?? ""
			let topStringAttributed = NSAttributedString(string: topString, attributes: attributes)
			topStringAttributed.draw(with: CGRect(x: 32, y: 16, width: imageSize.width - 64, height: 64), options: .usesLineFragmentOrigin, context: nil)

			let bottomString = self?.bottomText ?? ""
			let bottomStringAttributed = NSAttributedString(string: bottomString, attributes: attributes)
			bottomStringAttributed.draw(with: CGRect(x: 32, y: imageSize.height - 42, width: imageSize.width - 64, height: 64), options: .usesLineFragmentOrigin, context: nil)
		}

		imageView.image = memeImage
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
