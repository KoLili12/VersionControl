//
//  ObjectTableViewCell.swift
//  VersionControl
//
//  Created by Николай Жирнов on 13.09.2025.
//

import UIKit

final class ObjectTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var objectView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var objectsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var objectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var creatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var personIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Add main container
        contentView.addSubview(objectView)
        
        // Add image
        objectView.addSubview(objectsImageView)
        
        // Setup content stack
        objectView.addSubview(contentStackView)
        
        // Add status view
        objectView.addSubview(statusView)
        statusView.addSubview(statusLabel)
        
        // Setup date stack
        dateStackView.addArrangedSubview(calendarIcon)
        dateStackView.addArrangedSubview(dateLabel)
        
        // Setup creator stack
        creatorStackView.addArrangedSubview(personIcon)
        creatorStackView.addArrangedSubview(creatorLabel)
        
        // Add all labels to content stack
        contentStackView.addArrangedSubview(objectLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(addressLabel)
        contentStackView.addArrangedSubview(dateStackView)
        contentStackView.addArrangedSubview(creatorStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Main container
            objectView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            objectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            objectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            objectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Image
            objectsImageView.topAnchor.constraint(equalTo: objectView.topAnchor, constant: 12),
            objectsImageView.leadingAnchor.constraint(equalTo: objectView.leadingAnchor, constant: 12),
            objectsImageView.widthAnchor.constraint(equalToConstant: 80),
            objectsImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Status view
            statusView.topAnchor.constraint(equalTo: objectView.topAnchor, constant: 12),
            statusView.trailingAnchor.constraint(equalTo: objectView.trailingAnchor, constant: -12),
            statusView.heightAnchor.constraint(equalToConstant: 24),
            statusView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 4),
            statusLabel.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -4),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -8),
            
            // Content stack
            contentStackView.topAnchor.constraint(equalTo: objectView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: objectsImageView.trailingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: objectView.bottomAnchor, constant: -12),
            
            // Icons size
            calendarIcon.widthAnchor.constraint(equalToConstant: 12),
            calendarIcon.heightAnchor.constraint(equalToConstant: 12),
            personIcon.widthAnchor.constraint(equalToConstant: 12),
            personIcon.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    // MARK: - Configuration
    func configure(with object: Object) {
        objectLabel.text = object.name
        descriptionLabel.text = object.description.isEmpty ? "Нет описания" : object.description
        addressLabel.text = "📍 \(object.address)"
        
        // Configure status
        statusLabel.text = getStatusText(object.status)
        statusView.backgroundColor = getStatusColor(object.status)
        
        // Configure dates
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd.MM.yy"
        displayFormatter.locale = Locale(identifier: "ru_RU")
        
        var dateText = ""
        if let startDate = isoFormatter.date(from: object.startDate) {
            dateText = displayFormatter.string(from: startDate)
            if let endDate = isoFormatter.date(from: object.endDate) {
                dateText += " - " + displayFormatter.string(from: endDate)
            }
        } else {
            // Fallback: берём только дату без времени
            let startSimple = String(object.startDate.prefix(10))
            let endSimple = String(object.endDate.prefix(10))
            dateText = "\(startSimple) - \(endSimple)"
        }
        dateLabel.text = dateText
        
        // Configure creator
        creatorLabel.text = "Создал: \(object.creator.firstName) \(object.creator.lastName)"
    }
    
    private func getStatusText(_ status: String) -> String {
        switch status.lowercased() {
        case "active":
            return "Активный"
        case "completed":
            return "Завершён"
        case "paused":
            return "Приостановлен"
        case "planning":
            return "Планируется"
        default:
            return status.capitalized
        }
    }
    
    private func getStatusColor(_ status: String) -> UIColor {
        switch status.lowercased() {
        case "active":
            return .systemGreen
        case "completed":
            return .systemBlue
        case "paused":
            return .systemOrange
        case "planning":
            return .systemPurple
        default:
            return .systemGray
        }
    }
}
