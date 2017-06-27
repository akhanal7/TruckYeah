//
//  MenuViewController.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 12/23/16.
//  Copyright © 2016 ChooChoo Computing. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableViewMenuOptions: UITableView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var menuToggleBtn: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var menuHiddenConstraint: NSLayoutConstraint!
    
    private var menuShowingConstraint: NSLayoutConstraint!
    
    
    enum ContainmentState {
        case containingTrucksScreen(TrucksViewController)
        case containingProfileScreen(ProfileViewController)
        case containingSettingsScreen(UIViewController)
        
        func viewController() -> UIViewController {
            switch self {
            case .containingTrucksScreen(let vc):
                return vc
            case .containingProfileScreen(let vc):
                return vc
            case .containingSettingsScreen(let vc):
                return vc
            }
        }
    }
    
    enum HamburgerMenuOption : Int {
        case trucks
        case profile
        case settings
        case logout
    }
    
    fileprivate var containmentState: ContainmentState! {
        didSet {
            // need to grab nav bar properties from the contained view controller
            // because we aren't pushing it on, bu tsubstituting it out.
            self.title = containmentState.viewController().title
            self.navigationItem.setRightBarButtonItems(containmentState.viewController().navigationItem.rightBarButtonItems, animated: false)
        }
    }
    
    private var menuIsVisible: Bool {
        return tableViewMenuOptions.frame.origin.x >= 0
    }
    var currentRowVisible = 0
    
    // MARK: - Gesture Recognizing
    
    @IBAction func dismissMenuViewController(gestureRecognizer: UITapGestureRecognizer) {
        let loc = gestureRecognizer.location(in: tableViewMenuOptions)
            // no animation if we tap in the tableView or its already off screen
        if tableViewMenuOptions.bounds.contains(loc) {
            return
        }
        hideMenu()
    }
    
    @IBAction func toggleMenuViewController(_ sender: Any) {
        if menuIsVisible {
            hideMenu()
        } else {
            showMenu()
        }
    }
    
    private func addSlideMenuButton(){
        let btnImage = defaultMenuImage()
        menuToggleBtn.title = ""
        menuToggleBtn.setBackgroundImage(btnImage, for: .normal, barMetrics: .default)
    }
    
    private func hideMenu() {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.tableViewMenuOptions.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: self.tableViewMenuOptions.frame.origin.y, width: self.tableViewMenuOptions.frame.width,height: self.tableViewMenuOptions.frame.height)
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            self.tapGestureRecognizer.isEnabled = false
            NSLayoutConstraint.deactivate([self.menuShowingConstraint])
            NSLayoutConstraint.activate([self.menuHiddenConstraint])
            self.tableViewMenuOptions.layer.shadowOpacity = 0.0

        })
        
    }
    
    private func showMenu() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.tableViewMenuOptions.frame = CGRect(x: 0, y: self.tableViewMenuOptions.frame.origin.y, width: self.tableViewMenuOptions.frame.width,height: self.tableViewMenuOptions.frame.height)
            self.view.layoutIfNeeded()
            self.tableViewMenuOptions.layer.shadowOpacity = 0.8
        }, completion: { (finished) -> Void in
            self.tapGestureRecognizer.isEnabled = true
            
            NSLayoutConstraint.deactivate([self.menuHiddenConstraint])
            NSLayoutConstraint.activate([self.menuShowingConstraint])
        })
    }
    
    private func defaultMenuImage() -> UIImage {
        var defaultMenuImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 44, height: 44), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(roundedRect: CGRect(x: 0, y: 3, width: 21, height: 4), cornerRadius: 4.0).fill()
        UIBezierPath(roundedRect: CGRect(x: 0, y: 13, width: 21, height: 4),cornerRadius:4.0).fill()
        UIBezierPath(roundedRect: CGRect(x: 0, y: 23, width: 21, height: 4),cornerRadius:4.0).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return defaultMenuImage;
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuOption") as! MenuOptionCell
        switch indexPath.row {
        case 0:
            cell.selectionStyle = .default
            cell.customImage.image = #imageLiteral(resourceName: "van")
            cell.customText.text = "Trucks"
            cell.tag = HamburgerMenuOption.trucks.rawValue
        case 1 where FIRAuth.auth()?.currentUser != nil:
            let style: UITableViewCellSelectionStyle
            if FIRAuth.auth()?.currentUser == nil {
                style = .gray
            } else {
                style = .default
            }
            cell.selectionStyle = style
            cell.customImage.image = #imageLiteral(resourceName: "chef")
            cell.customText.text = "Profile"
            cell.tag = HamburgerMenuOption.profile.rawValue
        
        case 1,
             2 where FIRAuth.auth()?.currentUser != nil:
            cell.selectionStyle = .default
            cell.customImage.image = #imageLiteral(resourceName: "settings")
            cell.customText.text = "Settings"
            cell.tag = HamburgerMenuOption.settings.rawValue
        case 2,3:
            cell.selectionStyle = .default
            cell.customImage.image = #imageLiteral(resourceName: "logout")
            cell.customText.text = "Logout"
            cell.tag = HamburgerMenuOption.logout.rawValue
            
            
        default:
            print("unsupported menu cell requested, currently only 3 options")
        }
        
        cell.selectionStyle = .blue
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FIRAuth.auth()?.currentUser != nil ? 4 : 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == currentRowVisible {
            hideMenu()
            return
        }
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.tag == 3 {
            // logout
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            //unwind
            performSegue(withIdentifier: SegueIdentifier.AllTrucks.unwindFromTrucksMenu, sender: self)
            return
        }
        var oldViewController, newViewController: UIViewController
    
        switch containmentState! {
        case let .containingTrucksScreen(trucksViewController):
            oldViewController = trucksViewController
        case let .containingProfileScreen(profileViewController):
            oldViewController = profileViewController
        case let .containingSettingsScreen(settingsViewControler):
            oldViewController = settingsViewControler
        }        
        
        switch  cell.tag {
        case 0:
            let storyBoard = UIStoryboard(name: "AllTrucks", bundle: nil)
            let trucksViewController = storyBoard.instantiateViewController(withIdentifier: "trucksViewController") as! TrucksViewController
            containmentState = .containingTrucksScreen(trucksViewController)
            let truckStore = TruckWebService()
            trucksViewController.truckStore = truckStore
            newViewController = trucksViewController
        case 1:
            guard FIRAuth.auth()?.currentUser != nil else {
                return
            }
            let profileViewController = ProfileViewController(nibName: "Profile", bundle: Bundle.main)
            profileViewController.webService = TruckWebService()
            containmentState = .containingProfileScreen(profileViewController)
            newViewController = profileViewController
        case 2:
            let view = UIView(frame: UIScreen.main.bounds)
            let viewController = UIViewController()
            viewController.view = view
            containmentState = .containingSettingsScreen(viewController)
            newViewController = viewController
        default:
            fatalError("row selected unaccounted for")
        }
        oldViewController.willMove(toParentViewController: nil)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        newViewController.willMove(toParentViewController: self)
        self.addChildViewController(newViewController)
    
        
        let anim = {() -> Void in
            NSLayoutConstraint.activate([
                self.containerView.topAnchor.constraint(equalTo: newViewController.view.topAnchor),
                self.containerView.bottomAnchor.constraint(equalTo: newViewController.view.bottomAnchor),
                self.containerView.leadingAnchor.constraint(equalTo: newViewController.view.leadingAnchor),
                self.containerView.trailingAnchor.constraint(equalTo: newViewController.view.trailingAnchor),
                ])
        }

        self.transition(from: oldViewController, to: newViewController, duration: 0.15, options: .transitionCrossDissolve, animations: anim) { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            
                self.hideMenu()
        }
        
        currentRowVisible = indexPath.row
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setRightBarButtonItems(containmentState.viewController().navigationItem.rightBarButtonItems, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    // MARK: - UIView overrides
    
    override func viewDidLoad() {
        self.title = "All Trucks"
        navigationItem.titleView = UIView()
        super.viewDidLoad()
        addSlideMenuButton()
        
        menuShowingConstraint = tableViewMenuOptions.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        tableViewMenuOptions.layer.masksToBounds = false
        tableViewMenuOptions.layer.shadowColor = UIColor.black.cgColor
        tableViewMenuOptions.layer.shadowOffset = CGSize(width: 0.3, height: 0.0)
        tableViewMenuOptions.layer.shadowOpacity = 0.0
        tableViewMenuOptions.layer.shadowRadius = 7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let row: Int
        switch containmentState! {
        case .containingTrucksScreen:
            row = 0
        case .containingProfileScreen:
            row = 1
        case .containingSettingsScreen:
            row = 2
        }
        let index = IndexPath(row: row, section: 0)
        tableViewMenuOptions.selectRow(at: index, animated: true, scrollPosition: .none)
        if let cell = tableViewMenuOptions.cellForRow(at: index) as? MenuOptionCell {
            cell.setHighlighted(true, animated: false)        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch destination(for: segue, type: SegueIdentifier.AllTrucks.self) {
        case let .showProfile(profileViewController):
            containmentState = .containingProfileScreen(profileViewController)
        case let .showSettings(viewController):
            containmentState = .containingSettingsScreen(viewController)
        case let .showTrucks(trucksViewController):
            containmentState = .containingTrucksScreen(trucksViewController)
            let truckStore = TruckWebService()
            trucksViewController.truckStore = truckStore
            tapGestureRecognizer.isEnabled = true
        case .unwindFromTrucksMenu(_):
            break
        default:
            preconditionFailure("consider renaming segues nick")
        }
        
    }
}
