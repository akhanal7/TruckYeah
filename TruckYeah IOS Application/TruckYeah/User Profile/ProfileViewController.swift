//
//  UserProfile.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 12/26/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase
import Deferred

class ProfileViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var profilePicture: UIImageView!
    
    var imageAlertered = false, usernameAltered = false;
    
    var webService: TruckWebService!
    var user: FIRUser?
    lazy var overlay: UIVisualEffectView =  {
        Bundle.main.loadNibNamed("ProfilePictureOverlay", owner: self, options: nil)?.first! as! UIVisualEffectView
    }()
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "User Profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ProfileViewController not created with Coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        user = FIRAuth.auth()?.currentUser
        guard user != nil else {
            assertionFailure("ProfileViewController created without a user object")
            return
        }
        usernameTextField.text = user?.displayName ?? user?.email
        emailTextField.text = user?.email
        profilePicture.clipsToBounds = true
    }
    
    func loadProfilePicture() -> Task<UIImage> {
        let imageName = "\(FIRAuth.auth()!.currentUser!.uid).png"
        print("NICK: \(imageName)")
        let profilePictureTask = webService.fetchProfileImage(imageName)
        return profilePictureTask
    }
    
    func editTapped(sender: UIBarButtonItem) {
        
        usernameTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        
        // animate the rounded corners
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = 5.0
        animation.toValue = 25.0
        animation.duration = 0.5
        profilePicture.layer.removeAllAnimations()
        profilePicture.layer.cornerRadius = 25.0
        profilePicture.layer.add(animation, forKey: "cornerRadius")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped(sender:)))
        self.parent?.navigationItem.setRightBarButton(doneButton, animated: true)
        
        // text field configurations
        tapGestureRecognizer.isEnabled = true
        usernameTextField.backgroundColor = UIColor.white
        // camera overlay        
        profilePicture.addSubview(overlay)
    }
    
    func doneTapped(sender: UIBarButtonItem) {
        // handle image upload first
        if imageAlertered {
            let uid = FIRAuth.auth()!.currentUser!.uid
            let imageName = "\(uid).png"
            let directory_ref = FIRStorage.storage().reference(forURL: "gs://truckyeah-3d80f.appspot.com").child("profile")
            let image_ref = directory_ref.child(imageName)
            
            let data = UIImagePNGRepresentation(profilePicture.image!)
            
            let firebaseUploadTask = image_ref.put(data!, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                //let downloadURL = metadata.downloadURL
            }
            let _ = firebaseUploadTask.observe(.success)  { snapshot in
                let downloadURL = snapshot.metadata?.downloadURL()
                
                let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                changeRequest?.displayName = self.usernameTextField.text
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges(completion: { [weak self] error in
                    if error != nil {
                        // present alert error here and don't leave edit more
                    } else {
                        self?.exitEditMode()
                    }
                })
            }
        } else if usernameAltered {
            let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
            changeRequest?.displayName = self.usernameTextField.text
            changeRequest?.commitChanges(completion: { [weak self] error in
                if error != nil {
                    // present alert error here and don't leave edit more
                } else {
                    self?.exitEditMode()
                }
            })
        } else {
            self.exitEditMode()
        }
        imageAlertered = false
        usernameAltered = false
    }
    
    private func exitEditMode() {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = 25.0
        animation.toValue = 5.0
        animation.duration = 0.5
        profilePicture.layer.removeAllAnimations()
        profilePicture.layer.cornerRadius = 5.0
        profilePicture.layer.add(animation, forKey: "cornerRadius")
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editTapped(sender:)))
        self.parent?.navigationItem.setRightBarButton(editBtn, animated: true)
        
        // text field de-configurations
        self.view.endEditing(true)
        usernameTextField.isUserInteractionEnabled = false
        tapGestureRecognizer.isEnabled = false
        usernameTextField.backgroundColor = UIColor.clear
        
        
        // remove camera overlay
        overlay.removeFromSuperview()
    }
    
    @IBAction func pickProfilePicture(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    deinit {
        print("profile view controller deallocated")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if profilePicture.image == nil {
            presentHUDDuring(loadProfilePicture()) { result in
                self.profilePicture.image = try! result.extract()
            }
        }
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePicture.layer.cornerRadius = 5.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
 
    override func viewWillLayoutSubviews() {
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editTapped(sender:)))
        self.parent?.navigationItem.setRightBarButton(editBtn, animated: false)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicture.image = image
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped(sender:)))
        self.parent?.navigationItem.setRightBarButton(doneButton, animated: true)
        self.imageAlertered = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped(sender:)))
        self.parent?.navigationItem.setRightBarButton(doneButton, animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.usernameAltered = true
    }
}
