//
//  CreateReviewViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/16/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit
import FirebaseAuth


class CreateReviewViewController : UIViewController {
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var reviewTitle: UITextField!
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var reviewAuthor: UILabel!
    @IBOutlet var anonSwitch: UISwitch!
    
    
    let reviewStore = ReviewStore()
    var truckID: NSNumber!
    
    var author: String {
        if anonSwitch.isOn {
            return "Anonymous"
        } else {
            return FIRAuth.auth()?.currentUser?.displayName ?? "Anonymous"
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        print("tapped")
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.layer.borderColor = UIColor.darkGray.cgColor
        reviewTextView.layer.borderWidth = 1
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        // TODO: Add an are you sure you want to cancel?
        dismiss(animated: true, completion: {
            print("Review Cancelled")
        })
    }
    
    
    
    @IBAction func donePressed(sender: UIButton) {
        if !validateReview() {
            return
        }
        let review = Review(author: self.author,
                            reviewText: self.reviewTextView!.text!,
                            truckID: self.truckID,
                            title: self.reviewTitle!.text!)
        self.reviewStore.addNewReview(review) { (error) in
            if error != nil {
                self.present(error!)
            } else {
                self.dismiss(animated: true, completion: {
                    print("review submitted")
                })
            }
        }
    }
    
    private func validateReview() -> Bool {
        guard  !(reviewTitle.text?.isEmpty)!,
            !reviewTextView.text.isEmpty else {
                present(CreateReviewViewController.ReviewError.emptyInput)
                return false
        }
        return true
    }
    
    
}

extension CreateReviewViewController {
    enum ReviewError: Swift.Error {
        case emptyInput
    }
}

// MARK: Error Handling
extension CreateReviewViewController {
    func present(_ error: Swift.Error) {
        let message: String
        switch error {
        case ReviewError.emptyInput:
            message = "All fields must have values"
        case let error:
            message = error.localizedDescription
        }
        let alertControler = UIAlertController(title: "Error posting review",
                                               message: message + ". Must be logged in",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertControler.addAction(cancelAction)
        //OperationQueue.main.addOperation {
        self.show(alertControler, sender: self)
        //}
    }
}
