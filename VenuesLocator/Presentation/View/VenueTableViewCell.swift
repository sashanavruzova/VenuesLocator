//
//  VenueTableViewCell.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

/// `VenueTableViewCell` is responsible for configuring the UI of a table view cell that displays a venue.
/// It handles the UI elements and their layout, as well as providing a closure for toggling the favorite status.
class VenueTableViewCell: UITableViewCell {
    var toggleFavourite: (() -> Void)?
    
    private lazy var venueImageView: UIImageView = {
        let imageView = createImageView(cornerRadius: 5, width: 50, height: 50)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = createLabel(font: UIFont.boldSystemFont(ofSize: 16))
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = createLabel(font: UIFont.systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 2)
        return label
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(venueImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(favouriteButton)
        
        NSLayoutConstraint.activate([
            venueImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            venueImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            venueImageView.widthAnchor.constraint(equalToConstant: 50),
            venueImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: venueImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteButton.widthAnchor.constraint(equalToConstant: 24),
            favouriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with venue: Venue) {
        nameLabel.text = venue.name
        descriptionLabel.text = venue.shortDescription
        
        if let imageUrlString = venue.imageUrl, let imageUrl = URL(string: imageUrlString) {
            venueImageView.setImage(from: imageUrl)
        }
        
        let heartImageName = venue.isFavourite ? "heart_filled" : "heart_empty"
        if let heartImage = UIImage(named: heartImageName) {
            favouriteButton.setImage(heartImage.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc private func favouriteButtonTapped() {
        toggleFavourite?()
    }
    
    private func createImageView(cornerRadius: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
    
    private func createLabel(font: UIFont, textColor: UIColor = .black, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
}
