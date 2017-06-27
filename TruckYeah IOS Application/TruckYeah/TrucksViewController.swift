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
    var filtering = false
    //  indexed by truckID as NSNumber and each array of Dates
    // is when the truck is open
    var schedule: [NSNumber:[DayRange]]?
    
    lazy var loadSchedule: Void = {
        self.presentHUDDuring(self.fetchSchedule(), completion: { [weak self] result in
            try! self?.schedule = result.extract()
            self?.tableView.reloadData()
        })
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNavBar()
    }
    
    var displayedTrucks: [Truck] {
        if !filtering {
            return truckStore.allTrucks
        }
        return truckStore.allTrucks.filter { truck in
            let date = Date()
            let timeFormatter = DateFormatter()
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            timeFormatter.dateFormat = "HH:mm"
            let timeString = timeFormatter.string(from: date)
            let dayString = dayFormatter.string(from: date)
            let time = TimeRange.Time(militaryTime: timeString)
            let day = DayRange.Day(rawValue: dayString)
            if let dayAvailable = (schedule![truck.id]!.first(where: { scheduleDay in
                scheduleDay.day == day
            })?.timeRange.contains(time)) {
                return dayAvailable
            } else {
                return false
            }
        }
    }
    

    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if displayedTrucks.count > 0 {
            return 170
        } else {
            return tableView.frame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayedTrucks.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoTrucksCell")
            tableView.isScrollEnabled = false
            cell?.selectionStyle = .none // hack, should do this wtih tableview delegate methods
            // set selectable to false
            return cell!
        }
        tableView.isScrollEnabled = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath) as! TruckCell
        cell.selectionStyle = .none
        cell.paddingView.layer.cornerRadius = 10.0
        cell.paddingView.clipsToBounds = true
        let truck = displayedTrucks[indexPath.row]
        if let bg = truck.backgroundImage {
            cell.truckImage.image = bg
            cell.layer.cornerRadius = 10.0
            cell.clipsToBounds = true
            
        } else {
            fatalError("Failed to download truck images properly, or failed to acquire them")
        }
        cell.nameLabel.text = truck.name
        cell.truckID = truck.id

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (displayedTrucks.count > 0) ? displayedTrucks.count : 1
    }
    
    // MARK: - GETting data from web service
    func loadImages() -> Task<Void>{
        let truckCellsTask = truckStore.fetchTrucks()
        let loadedPics = truckCellsTask.andThen(upon: DispatchQueue.any()) {[unowned self] (trucks: [Truck])  -> Task<Void> in
            self.truckStore.allTrucks = trucks
            let truckImageTask = self.truckStore.fetchImagesFor(trucks)
            return truckImageTask.ignored()
        }
        return loadedPics
    }
    
    func fetchSchedule() -> Task<[NSNumber:[DayRange]]> {
        let scheduleTask = truckStore.fetchSchedule()
        return scheduleTask
    }
    
    func handleImagesLoaded() {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if truckStore.expired {
            presentHUDDuring(loadImages()) { [weak self] _ in
                self?.handleImagesLoaded()
            }
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        tableView.rowHeight = 170
    }
    
    @objc private func toggleSchedule(sender: UIBarButtonItem) {
        filtering = !filtering
        if schedule != nil {
            tableView.reloadData()
            if displayedTrucks.count > 0 {
                tableView.isScrollEnabled = true
            } else {
                tableView.isScrollEnabled = false
            }
        }
        _ = loadSchedule
    }
    
    private func setNavBar() {
        let text = "Filter on Campus"
        
        let toggleLabel = UILabel()
        toggleLabel.numberOfLines = 0
        toggleLabel.text = text
        toggleLabel.sizeToFit()
        let barButton1 = UIBarButtonItem(customView: toggleLabel)
        
        let toggleSwitch = UISwitch()
        toggleSwitch.addTarget(self, action: #selector(toggleSchedule(sender:)), for: .valueChanged)
        
        let barButton2 = UIBarButtonItem(customView: toggleSwitch)
        self.navigationItem.setRightBarButtonItems([barButton2, barButton1], animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch destination(for: segue, type: SegueIdentifier.AllTrucks.self) {
        case .showFoodMenu(let tabBarController):
            guard let selectedCellIndex = tableView.indexPathForSelectedRow else {
                preconditionFailure("StoryboardSegue to truck menu triggered without a selected truck")
            }
            let selectedTruck = displayedTrucks[selectedCellIndex.row]
            tabBarController.navigationItem.title = selectedTruck.name
            let dataSource = FoodMenuDataSource(menu: selectedTruck.menu)
            let foodMenuViewController = tabBarController.childViewControllers.first! as! FoodMenuViewController
            foodMenuViewController.menuDataSource = dataSource
            
            let reviewsTableViewController = tabBarController.childViewControllers[1] as! ReviewsTableViewController
            reviewsTableViewController.truckID = selectedTruck.id
        default:
            preconditionFailure("Consider renaming your segue identifiers so this doesn't happen")
        }
    }
    
    deinit {
        print("truck view controller deallocated")
    }
    
    
    
}
