
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
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    
    var imageAlertered = false, usernameAltered = false;
    
    var webService: TruckWebService!
    var user: FIRUser?
    lazy var overlay: UIView =  {
        let v = Bundle.main.loadNibNamed("ProfilePictureOverlay", owner: self, options: nil)?.first! as! UIView
        //v.gestureRecognizers?.first!.addTarget(self, action: #selector(pickProfilePicture(_:)))
        return v
    }()
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "User Profile"
        setEditBtn()
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
        emailLabel.text = user?.email
        profilePicture.clipsToBounds = true
    }
    
    func loadProfilePicture() -> Task<UIImage> {
        let imageName = "\(FIRAuth.auth()!.currentUser!.uid).png"
        let profilePictureTask = webService.fetchProfileImage(imageName)
        return profilePictureTask
    }
    
    func editTapped(sender: UIBarButtonItem) {
        
        usernameTextField.isUserInteractionEnabled = true
        
        // animate the rounded corners
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = 5.0
        animation.toValue = 25.0
        animation.duration = 0.5
        profilePicture.layer.removeAllAnimations()
        profilePicture.layer.cornerRadius = 25.0
        profilePicture.layer.add(animation, forKey: "cornerRadius")
        setDoneBtn()
        
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
            
            if var sizedImage = profilePicture.image {
                var data = UIImagePNGRepresentation(sizedImage)
                if let size = data?.count, size > 2000000 { // shrink image to < 1MB
                    let percentToShrink = 2000000.0 / CGFloat(size)
                    sizedImage = sizedImage.resized(withPercentage: percentToShrink)
                    data = UIImagePNGRepresentation(sizedImage)
                }
                
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
        setEditBtn()
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

    fileprivate func setEditBtn() {
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editTapped(sender:)))
        self.navigationItem.setRightBarButton(editBtn, animated: false)
        parent?.navigationItem.setRightBarButton(navigationItem.rightBarButtonItem, animated: false)
    }
    
    fileprivate func setDoneBtn() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped(sender:)))
        navigationItem.setRightBarButton(doneButton, animated: true)
        self.parent?.navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItem
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        profilePicture.image = image
        setDoneBtn()
        imageAlertered = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        setDoneBtn()
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.usernameAltered = true
    }
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
