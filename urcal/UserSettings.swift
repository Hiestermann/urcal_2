//
//  UserEdit.swift
//  urcal
//
//  Created by Kilian Hiestermann on 01.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

class UserSettings: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User? = nil
    
    var profilImage: UIImage? = nil
    var username: String? = nil
    
    let cellId = "cellId"
    let sectionTopHeaderId = "sectionTopHeader"
    let sectionHeader = "sectionHeader"
    let section0CellId = "section0CellId"
    let section1CellId = "section1CellId"
    let section2CellId = "section2CellId"
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        image.image = UIImage(named: "profil_dummy")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        collectionView?.backgroundColor = .white
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        // register header for section 0
        collectionView?.register(UserEditSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionTopHeaderId)
        // register header for section 1 and 2
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeader)
        // register cell for section 0
        collectionView?.register(UsernameSettingsCell.self, forCellWithReuseIdentifier: section0CellId)
        // register cell for section 1
        collectionView?.register(Section1ButtonCell.self, forCellWithReuseIdentifier: section1CellId)
        // register cell for section 2
        collectionView?.register(Section2ButtonCell.self, forCellWithReuseIdentifier: section2CellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoSelector), name: .showPhotoSelector, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUsername), name: .handleUsernameUserSettings, object: nil)
        
        setupNavBar()

    }
    
    // get the new Username from UsernameSettingsCell
    func handleUsername(notification: Notification) {
        guard let username = notification.object as? String else { return }
        self.username = username
    }
    
    fileprivate func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        var checkForUpload = false
        
        if username != nil {
            updateUsername(uid: uid)
            checkForUpload = true
        }
        
        if profilImage != nil {
            updateUserImage(uid: uid)
            checkForUpload = true
            
        }
        

        if checkForUpload == true {
            //NOTE: -reload UserPostsView, Bookmarks and HomeViewController
            NotificationCenter.default.post(name: .refreshHomeController, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
  
    fileprivate func updateUsername(uid: String) {
        
        let values = ["username": username]
        
        Database.database().reference().child("users").child(uid).updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err)
            }
        }
    }
    
    fileprivate func updateUserImage(uid: String) {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        //            FIRStorage.storage().reference(forURL: profileImageUrl).delete(completion: { (err) in
        //                if let err = err {
        //                    print(err)
        //                }
        //            })
        
        // Update Userimage
        guard let uploadData = UIImageJPEGRepresentation(profilImage!, 0.3) else { return }
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
            if let err = err {
                print (err)
            }
            
            guard let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
            
            let pictureValue = ["profileImageURL": profileImageURL]
            
            Database.database().reference().child("users").child(uid).updateChildValues(pictureValue, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                }
            })
        })
    }
    
    func showPhotoSelector() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profilImage = editedImage
            NotificationCenter.default.post(name: .setUserImage, object: editedImage)
            
        }else if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage{
            NotificationCenter.default.post(name: .setUserImage, object: originalImage)
        }

        dismiss(animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            handleLogOut()
        }
        if indexPath.section == 2 {
            handleDeleteUser()
        }
        
    }
    
    func handleDeleteUser() {
        
    }
    
    func handleLogOut() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do{
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController =  UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let singOutErr {
                print("faild to log out", singOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 150)
        }else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if section == 0 {                   // Number of Items in section 0
            return 1
        } else if section == 1 {            // Number of Items in section 1
            return 1
        } else if section == 2 {            // Number of Items in section 2
            return 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if indexPath.section == 0{
            let section0Cell = collectionView.dequeueReusableCell(withReuseIdentifier: section0CellId, for: indexPath) as! UsernameSettingsCell
            section0Cell.usernameTextField.text = user?.username
            return section0Cell
        
        } else if indexPath.section == 1{
            let section1Cell = collectionView.dequeueReusableCell(withReuseIdentifier: section1CellId, for: indexPath) as! Section1ButtonCell
            return section1Cell
       
        } else if indexPath.section == 2 {
            let section2Cell = collectionView.dequeueReusableCell(withReuseIdentifier: section2CellId, for: indexPath) as! Section2ButtonCell
            return section2Cell
            
        } else {
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let sectionTopHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionTopHeaderId, for: indexPath) as! UserEditSectionHeaderView
            
            if let imageUrl = self.user?.profileImageUrl {
                if imageUrl != "" {
            sectionTopHeader.userImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
                }
            }
            return sectionTopHeader
        } else {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionHeader, for: indexPath)
            return sectionHeader
        }
        
        
    }
    
    fileprivate func setupView() {
        view.addSubview(userImage)
    }
    
}
