//
//  VenuesViewController.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

/// `VenuesViewController` is responsible for setting up the views and configuring the cells.
/// It manages the display of a list of venues and handles user interactions such as toggling favorites.
class VenuesViewController: UIViewController {
    private let viewModel: VenuesViewModel
    private var venues: [Venue] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: "VenueCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: VenuesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
        setupLoadingIndicator()
    }
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loadingIndicator.startAnimating()
    }
    
    private func updateLoadingState(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func animateVisibleCells() {
        let visibleCells = tableView.visibleCells
        for (index, cell) in visibleCells.enumerated() {
            let delay = 0.05 * Double(index)
            cell.withBounceAnimation(delay: delay)
        }
    }
}

extension VenuesViewController: VenuesViewModelDelagate {
    func didUpdateVenues(_ venues: [Venue], withAnimation: Bool) {
        self.venues = venues
        updateLoadingState(isLoading: false)
        tableView.reloadData()
        
        if withAnimation {
            animateVisibleCells()
        }
    }
    
    func didfailWithError(_ error: any Error) {
        updateLoadingState(isLoading: false)
        print(error.localizedDescription)
    }
}

extension VenuesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as? VenueTableViewCell else {
            return UITableViewCell()
        }
        
        let venue = venues[indexPath.row]
        configure(cell: cell, with: venue)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configure(cell: VenueTableViewCell, with venue: Venue) {
        cell.configure(with: venue)
        cell.toggleFavourite = { [weak self] in
            self?.handleFavouriteToggle(for: venue)
        }
    }
    
    private func handleFavouriteToggle(for venue: Venue) {
        viewModel.toggleFavourite(for: venue)
    }
}
