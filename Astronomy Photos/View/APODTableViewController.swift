//
//  ListOfPhotosTableViewController.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 4.08.2023.
//

import UIKit
class APODTableViewController: UITableViewController, AddNewRequestTableViewControllerDelegate {
    
    // MARK: - UI Elements
    
    
    // MARK: - Properties
    var photoInfoArray: [PhotoInfo] = []
    
    var isHDQuality: Bool = false
    
    var selectedPhotoInfo: PhotoInfo?
    var selectedPhotoIndexPath: Int = 0
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Functions
    
    func sendPhotoInfo(photoInfo: PhotoInfo, quality: Bool) {
        if photoInfoArray.contains(photoInfo) {
            
            DispatchQueue.main.async {
                self.alertMessage("Kayıt Mevcut", "\(photoInfo.date) tarihli kayıt mevcut.")
            }
            
        }else {
            photoInfoArray.append(photoInfo)
            isHDQuality = quality
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoReuseIdentifier")! as! PhotoInfoTableViewCell
        
        cell.updateCellUI(photoInfoArray[indexPath.row], isHDQuality: isHDQuality)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedPhotoInfo = photoInfoArray[indexPath.row]
        selectedPhotoIndexPath = indexPath.row
        
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedCell = photoInfoArray.remove(at: sourceIndexPath.row)
        photoInfoArray.insert(selectedCell, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            photoInfoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddAstronomyRequest" {
            guard let navigationController = segue.destination as? UINavigationController else { fatalError() }
            
            guard let addNewRequest = navigationController.viewControllers.first as? AddNewRequestTableViewController else { fatalError() }
            
            addNewRequest.delegate = self
            
        }
        else if segue.identifier == "toDetail" {
            guard let detailDestination = segue.destination as? DetailViewController else { return }
            detailDestination.photoInfo = selectedPhotoInfo
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addBarButtonTapped(_ barButton: UIBarButtonItem) {
        performSegue(withIdentifier: "toAddAstronomyRequest", sender: nil)
    }
    
    @IBAction func refreshButtonTapped() {
        tableView.reloadData()
        
    }
    
    @IBAction func editingButtonTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

extension APODTableViewController {
    
    func alertMessage(_ title: String?, _ message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true)
    }
}
