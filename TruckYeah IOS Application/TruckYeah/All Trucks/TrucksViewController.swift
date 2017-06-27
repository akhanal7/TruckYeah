//
//  RestaurantsViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 11/9/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit
import Deferred

class TrucksViewController: UITableViewController  {

    var truckStore: TruckWebService!
    
    
    // MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath) as! TruckCell
        cell.selectionStyle = .none
        
        let truck = truckStore.allTrucks[indexPath.row]
        if let bg = truck.backgroundImage {
            cell.backgroundView = UIImageView(image: bg)
        } else {
            fatalError("Failed to download truck images properly, or failed to acquire them")
        }
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.nameLabel.text = truck.name
        
        return cell
    }
    
    func loadImages() -> Task<Void>{
        let truckCellsTask = truckStore.fetchTrucks()
        let loadedPics = truckCellsTask.andThen(upon: DispatchQueue.any()) {[unowned self] (trucks: [Truck])  -> Task<Void> in
            self.truckStore.allTrucks = trucks
            let truckImageTask = self.truckStore.fetchImagesFor(trucks)
            return truckImageTask.ignored()
        }
        return loadedPics
    }
    
    func handleImagesLoaded() {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentHUDDuring(loadImages()) { [weak self] _ in
            self?.handleImagesLoaded()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return truckStore.allTrucks.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()    
        tableView.rowHeight = 170
        // might change if we have truck menus "unfold" from beneath the cells
        //tableView.estimatedRowHeight = 170
    }
    
    deinit {
        print("truck view controller deallocated")
    }
    
}
