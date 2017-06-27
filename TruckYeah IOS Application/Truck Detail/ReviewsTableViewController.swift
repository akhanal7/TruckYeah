//
//  ReviewsTableViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 4/3/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    var truckID: NSNumber?
    let reviewsStore = ReviewStore()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reviewsStore.reviews.count > 0) ? reviewsStore.reviews.count : 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // we set insets here rather than viewDidLoad because the containing navigation controller
        // is trying to autoadjust them, so we change them after it has done that.
        navigationController?.topViewController?.navigationItem.setRightBarButton(navigationItem.rightBarButtonItem, animated: false)
         tableView.contentInset = UIEdgeInsetsMake(self.navigationController?.navigationBar.frame.height ?? 0.0, 0.0, self.tabBarController!.tabBar.frame.height, 0);
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.topViewController?.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (reviewsStore.reviews.count > 0) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviewsStore.reviews[indexPath.row]
        
        cell.reviewerName?.text = review.author
        cell.reviewText?.text = review.reviewText
        cell.reviewTitle?.text = review.title
        
        return cell
        } else {
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoReviewsCell")
            return cell!
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.all;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        let height = navigationController?.navigationBar.frame.height
        tableView.contentInset = UIEdgeInsetsMake(height! + 8,0,0,0);
        guard let truckID = truckID else {
            return
        }
        let futureReviews = reviewsStore.getReviews(for: truckID)
        futureReviews.upon(.main) { (result) in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(let error):
                self.present(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewReview" {
            let createReviewViewController = segue.destination as! CreateReviewViewController
            createReviewViewController.truckID = truckID            
        }
    }
}

// MARK: Error Handling
extension ReviewsTableViewController {
    func present(_ error: Swift.Error) {
        let alertControler = UIAlertController(title: "Error getting reviews",
                                               message: "\(error)",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertControler.addAction(cancelAction)
        //OperationQueue.main.addOperation {
            self.show(alertControler, sender: self)
        //}
    }
}
