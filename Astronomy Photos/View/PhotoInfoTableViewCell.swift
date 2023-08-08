//
//  PhotoInfoTableViewCell.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 4.08.2023.
//

import UIKit

class PhotoInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    let networkController = NetworkController()
    
    func updateCellUI(_ photoInfo: PhotoInfo, isHDQuality: Bool) {
                
        if isHDQuality {
            
            guard let hdUrl = photoInfo.hdUrl else { return }
            
            networkController.fetchPhoto(from: hdUrl) { image in
                
                DispatchQueue.main.async {
                    if let image = image {
                        self.photoImageView.image = image
                    }
                }
            }
        }else {
            
            guard let url = photoInfo.url else { return }
            
            networkController.fetchPhoto(from: url) { image in
                DispatchQueue.main.async {
                    if let image = image {
                        self.photoImageView.image = image
                    }
                }
            }
        }
        
        titleLabel.text = photoInfo.title
        dateLabel.text = photoInfo.date
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.masksToBounds = true
    }
    
    // MARK: - Functions
    
    
    // MARK: - Actions
    

}
