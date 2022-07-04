//
//  DetailsVC.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    // MARK: - Properties -
    let viewModel = DetailsVM()
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.londonSky
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.competitionPurple
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.londonSky,
                             for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self,
                         action: #selector(callTapped),
                         for: .touchUpInside)
        button.setTitle("Call Business",
                        for: .normal)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect.zero)
        mapView.layer.cornerRadius = 8
        mapView.layer.masksToBounds = true
        mapView.delegate = self
        return mapView
    }()
    
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        fetchData()
    }
    
    // MARK: - Setup -
    private func setupUI() {
        view.backgroundColor = .white
        title = "Details"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "share"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(shareTapped))
        // ImageView
        view.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: 9/16)
        ])
        // Name label
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: topImageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
        // Bottom button
        view.addSubview(callButton)
        callButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            callButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -20),
            callButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 15),
            callButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -15),
            callButton.heightAnchor.constraint(equalToConstant: 44),
            
        ])
        // Map
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: callButton.topAnchor,
                                            constant: -20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                             constant: 15),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -15),
            mapView.topAnchor.constraint(equalTo: topImageView.bottomAnchor,
                                         constant: 15)
        ])
    }
    
    private func setupData() {
        guard let selectedBusiness = viewModel.selectedBusiness else {
            return
        }
        nameLabel.text = selectedBusiness.name
        if !selectedBusiness.imageUrl.isEmpty {
            topImageView.setImage(selectedBusiness.imageUrl)
        }
        guard let coordinates = selectedBusiness.coordinates,
              let latitude = coordinates.latitude,
              let longitude = coordinates.longitude else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
    }
    
    private func fetchData() {
        self.viewModel.userCoordinate = mapView.userLocation.coordinate
        self.viewModel.calculateRoot()
        self.viewModel.reloadedData = { [weak self] in
            if let polyline = self?.viewModel.polyline {
                self?.mapView.addOverlay(polyline)
            }
        }
    }
    
    // MARK: - Actions -
    @objc private func shareTapped() {
        guard let url = viewModel.selectedBusiness?.url else {
            return
        }
        let textToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController,
                     animated: true,
                     completion: nil)
    }
    
    @objc private func callTapped() {
        if let url = URL(string: "tel://\(viewModel.selectedBusiness?.phone ?? "")") {
            UIApplication.shared.open(url,
                                      options: [:]) { [unowned self] success in
                if !success {
                    let alert = UIAlertController(title: "",
                                                  message: "Call is not available",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .cancel))
                    self.present(alert,
                                 animated: true)
                }
            }
        }
    }
}

extension DetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.competitionPurple
        return renderer
    }
}
