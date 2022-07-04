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
    
    let viewModel = HomeVM()
    
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - Setup -
    private func setupUI() {
        self.view.backgroundColor = .white
        self.title = "Fitness studios";
        // Map
        view.addSubview(mapView)
        mapView.delegate = self
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
        let center = CLLocationCoordinate2D(latitude: viewModel.latitude,
                                            longitude: viewModel.longitude)
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
    }
    
    // MARK: - Actions -
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        viewModel.saveHomeScreenState(index: selectedIndex)
        setupVisibility(selectedIndex: selectedIndex)
    }
    
    private func setupVisibility(selectedIndex: Int) {
        mapView.isHidden = selectedIndex == 1
        tableView.isHidden = selectedIndex == 0
    }
    
    private func fetchData() {
        segmentedControl.selectedSegmentIndex = viewModel.homeScreenState().rawValue
        activityIndicator.startAnimating()
        mapView.isHidden = true
        tableView.isHidden = true
        viewModel.fetchBusinessesData()
        viewModel.reloadedData = { [weak self] in
            DispatchQueue.main.async {
                guard let weakSelf = self else {
                    return
                }
                weakSelf.activityIndicator.stopAnimating()
                weakSelf.setupVisibility(selectedIndex: weakSelf.segmentedControl.selectedSegmentIndex)
                weakSelf.setupMapPins()
                weakSelf.tableView.reloadData()
                let center = CLLocationCoordinate2D(latitude: weakSelf.viewModel.latitude,
                                                    longitude: weakSelf.viewModel.longitude)
                let region = MKCoordinateRegion(center: center,
                                                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                       longitudeDelta: 0.01))
                weakSelf.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    private func setupMapPins() {
        mapView.removeAnnotations(mapView.annotations)
        guard let items = viewModel.data?.businesses else {
            return
        }
        for item in items {
            if let itemCoordinates = item.coordinates,
               let latitude = itemCoordinates.latitude,
               let longitude = itemCoordinates.longitude {
                let annotation = IdentifiableAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                               longitude: longitude)
                annotation.title = item.name
                var subtitle = ""
                if let price = item.price {
                    subtitle.append(contentsOf: price)
                    subtitle.append(contentsOf: " • ")
                }
                subtitle.append(contentsOf: String.init(format: "%.2f miles",
                                                        item.distance.getMiles()))
                annotation.subtitle = subtitle
                annotation.id = item.id
                mapView.addAnnotation(annotation)
            }
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data?.businesses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudioCell") as? StudioCell else {
            return UITableViewCell()
        }
        guard let item = viewModel.data?.businesses[indexPath.row] else {
            return UITableViewCell()
        }
        cell.rowIndex = indexPath.row
        cell.setupCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        guard let selectedBusiness = viewModel.data?.businesses[indexPath.row] else {
            return
        }
        let detailsVC = DetailsVC()
        detailsVC.viewModel.selectedBusiness = selectedBusiness
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension HomeVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation as! IdentifiableAnnotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: annotationIdentifier)
            let button =  UIButton(type: .detailDisclosure)
            button.tintColor = UIColor.competitionPurple
            annotationView?.rightCalloutAccessoryView = button
        }
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "pin")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? IdentifiableAnnotation else {
            return
        }
        let annotationId = annotation.id
        guard let selectedBusiness = viewModel.data?.businesses.filter({$0.id == annotationId}).first else {
            return
        }
        let detailsVC = DetailsVC()
        detailsVC.viewModel.selectedBusiness = selectedBusiness
        self.navigationController?.pushViewController(detailsVC,
                                                      animated: true)
    }
}

