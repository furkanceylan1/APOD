//
//  AddNewRequestTableViewController.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 3.08.2023.
//

/*
 title
 url
 date
 copyright
 explanation
 hdurl
 */

import UIKit

protocol AddNewRequestTableViewControllerDelegate: class {
    func sendPhotoInfo (photoInfo: PhotoInfo, quality: Bool)
}

class AddNewRequestTableViewController: UITableViewController {

    // MARK: - UI Elements
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var qualitySwitch: UISwitch!
    
    // MARK: - Properties
    weak var delegate: AddNewRequestTableViewControllerDelegate?
    
    var photosArray: [PhotoInfo] = []
    var photoInfo: PhotoInfo?
    
    let dateLabelIndexPath = IndexPath(row: 0, section: 0)
    let datePickerIndexPath = IndexPath(row: 1, section: 0)
    
    var isDatePickerShown: Bool = false {
        didSet {
            datePicker.isHidden = !isDatePickerShown
        }
    }
    
    var networkController = NetworkController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        dateLabel.text = dateFormater.string(from: Date())
        
        datePicker.maximumDate = Date()
        
    }
    
    // MARK: - Functions
    
    func alertController(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveButtonTapped(_ barButton: UIBarButtonItem) {
        guard let date = dateLabel.text else { return }
        let isHDQuality = qualitySwitch.isOn
        
        let query = [
            "api_key" : "DEMO_KEY",
            "date" : date
        ]
        
        networkController.fetchPhotoInfo(query: query) { result in
            
            switch result {
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.alertController(title: "Error", message: error.localizedDescription)
                }
                
            case .success(let photoInfo):
            
                DispatchQueue.main.async {
                    if let photoInfo = photoInfo {
                        if self.photosArray.contains(where: {$0.date == date}){
                            self.alertController(title: "Registration Available", message: nil)
                        }else {
                            self.photosArray.append(photoInfo)
                            if let delegate = self.delegate {
                                delegate.sendPhotoInfo(photoInfo: photoInfo, quality: isHDQuality)
                            }
                            self.photoInfo = photoInfo
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - Extensions

extension AddNewRequestTableViewController {
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
            
        case datePickerIndexPath:
            if isDatePickerShown{
                return 390
            }else{
                return 0
            }
            
        default:
            return 43.5
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
            
        case dateLabelIndexPath:
            if isDatePickerShown {
                isDatePickerShown = false
            }else {
                isDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }

}
