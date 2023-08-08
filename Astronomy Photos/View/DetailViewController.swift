//
//  DetailViewController.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 5.08.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var photoInfo: PhotoInfo?
    
    var networkController = NetworkController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        let longPressImageView = UILongPressGestureRecognizer(target: self, action: #selector(sharePhoto(_:)))
        longPressImageView.minimumPressDuration = 1
        imageView.addGestureRecognizer(longPressImageView)
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        if let photoInfo = photoInfo {

            DispatchQueue.main.async {
                
                self.networkController.fetchPhoto(from: photoInfo.url!) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
                
                self.titleLabel.text = photoInfo.title
                self.dateLabel.text = photoInfo.date
                self.descriptionLabel.text = photoInfo.description
            }
        }
    }
    
    // MARK: - Functions
    
    @objc func sharePhoto(_ sender: UILongPressGestureRecognizer?) {
        
        if sender?.state == .began {
            UIView.animate(withDuration: 0.25) {
                self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.allowsProminentActivity = true
        activityController.completionWithItemsHandler = { _ ,_ ,_ ,_ in
            UIView.animate(withDuration: 0.25) {
                self.imageView.transform = .identity
            }
        }
        present(activityController, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func shareButtonTapped(_ button: UIBarButtonItem) {
        sharePhoto(nil)
    }

}
