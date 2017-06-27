//
//  HUDViewController.swift
//  TotalTreasury
//
//  Created by John Gallagher on 12/5/16.
//  Copyright © 2016 D+H. All rights reserved.
//

import UIKit
import Deferred

final fileprivate class HUDViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        container.layer.cornerRadius = 10
        container.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.startAnimating()

        view.addSubview(container)
        container.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leadingAnchor.constraint(equalTo: activityIndicator.leadingAnchor),
            container.layoutMarginsGuide.trailingAnchor.constraint(equalTo: activityIndicator.trailingAnchor),
            container.layoutMarginsGuide.topAnchor.constraint(equalTo: activityIndicator.topAnchor),
            container.layoutMarginsGuide.bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
    }

}

extension UIViewController {
    func presentHUDDuring<F: FutureProtocol>(_ future: F, completion: @escaping (F.Value) -> Void) {
        let hud = HUDViewController()
        present(hud, animated: true) {
            future.upon(DispatchQueue.main) { result in
                hud.dismiss(animated: false) {
                    completion(result)
                }
            }
        }
    }
}
