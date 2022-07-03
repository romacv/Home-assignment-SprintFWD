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
    
    let homeVM = HomeVM()
    
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
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
        let center = CLLocationCoordinate2D(latitude: homeVM.latitude,
                                            longitude: homeVM.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
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
        let selectedIndex = sender.selectedSegmentIndex
        homeVM.saveHomeScreenState(index: selectedIndex)
        setupVisibility(selectedIndex: selectedIndex)
    }
    
    private func setupVisibility(selectedIndex: Int) {
        mapView.isHidden = selectedIndex == 1
        tableView.isHidden = selectedIndex == 0
    }
    
    private func fetchData() {
        segmentedControl.selectedSegmentIndex = homeVM.homeScreenState().rawValue
        setupVisibility(selectedIndex: segmentedControl.selectedSegmentIndex)
        activityIndicator.startAnimating()
        homeVM.fetchBusinessesData()
        homeVM.reloadedData = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.setupMapPins()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupMapPins() {
        mapView.removeAnnotations(mapView.annotations)
        for item in homeVM.data?.businesses ?? [] {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.coordinates.latitude,
                                                           longitude: item.coordinates.longitude)
            annotation.title = item.name
            annotation.subtitle = "\(item.price ?? "")" + " • \(item.distance)"
            mapView.addAnnotation(annotation)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeVM.data?.businesses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudioCell") as? StudioCell else {
            return UITableViewCell()
        }
        guard let item = homeVM.data?.businesses[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupCell(item: item)
        return cell
    }
    
    
}
