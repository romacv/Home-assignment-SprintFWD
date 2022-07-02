//
//  HomeVC.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 2/7/2022.
//

import UIKit
import MapKit

class HomeVC: UIViewController {
    
    // MARK: - Properties -
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero,
                                    style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudioCell.self, forCellReuseIdentifier: "StudioCell")
        return tableView
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect.zero)
        return mapView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Map", "List"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor.competitionPurple
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.backgroundColor = UIColor.londonSky
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_ :)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup -
    private func setupViews() {
        self.view.backgroundColor = .white
        self.title = "Fitness studios";
        // Map
        view.addSubview(mapView)
        mapView.isHidden = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let mapViewAttributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(mapViewAttributes.map {
            if $0 == .bottom {
                return NSLayoutConstraint(item: mapView,
                                          attribute: $0,
                                          relatedBy: .equal,
                                          toItem: mapView.superview,
                                          attribute: $0,
                                          multiplier: 1,
                                          constant: 0)
            }
            else {
                return NSLayoutConstraint(item: mapView,
                                          attribute: $0,
                                          relatedBy: .equal,
                                          toItem: view.safeAreaLayoutGuide,
                                          attribute: $0,
                                          multiplier: 1,
                                          constant: 0)
            }
        })
        // TableView
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewAttributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(tableViewAttributes.map {
            if $0 == .top {
                return NSLayoutConstraint(item: tableView,
                                          attribute: $0,
                                          relatedBy: .equal,
                                          toItem: view.safeAreaLayoutGuide,
                                          attribute: $0,
                                          multiplier: 1,
                                          constant: 88)
            }
            else {
                return NSLayoutConstraint(item: tableView,
                                          attribute: $0,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: $0,
                                          multiplier: 1,
                                          constant: 0)
            }
        })
        // Segmented
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: 28),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 184)
        ])
        // Activity Indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    // MARK: - Actions -
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        activityIndicator.stopAnimating()
        mapView.isHidden = sender.selectedSegmentIndex == 1
        tableView.isHidden = sender.selectedSegmentIndex == 0
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudioCell") as? StudioCell else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(named: "fitness")
        content.text = "Abc"
        content.secondaryText = "Def"
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .darkGray
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
