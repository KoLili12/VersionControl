//
//  DefectTableViewCell.swift
//  VersionControl
//
//  Created by Николай Жирнов on 05.10.2025.
//

import UIKit

// MARK: - Custom Defect Cell
class DefectTableViewCell: UITableViewCell {
    static let identifier = "DefectTableViewCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var statusBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priorityBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        containerView.addSubview(priorityBadge)
        priorityBadge.addSubview(priorityLabel)
        containerView.addSubview(createdAtLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Priority Badge - выровнен по левому краю
            priorityBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            priorityBadge.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            priorityBadge.heightAnchor.constraint(equalToConstant: 20),
            priorityBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            // Priority Label
            priorityLabel.centerXAnchor.constraint(equalTo: priorityBadge.centerXAnchor),
            priorityLabel.centerYAnchor.constraint(equalTo: priorityBadge.centerYAnchor),
            priorityLabel.leadingAnchor.constraint(equalTo: priorityBadge.leadingAnchor, constant: 8),
            priorityLabel.trailingAnchor.constraint(equalTo: priorityBadge.trailingAnchor, constant: -8),
            
            // Status Badge - рядом с приоритетом
            statusBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            statusBadge.leadingAnchor.constraint(equalTo: priorityBadge.trailingAnchor, constant: 8),
            statusBadge.heightAnchor.constraint(equalToConstant: 20),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Status Label
            statusLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -8),
            
            // Title Label - под бейджами
            titleLabel.topAnchor.constraint(equalTo: priorityBadge.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Description Label - больше места для описания
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: createdAtLabel.topAnchor, constant: -8),
            
            // Created At Label - в правом нижнем углу
            createdAtLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            createdAtLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(with defect: Defect) {
        titleLabel.text = defect.title
        descriptionLabel.text = defect.description
        
        // Setup status badge
        statusLabel.text = defect.status.displayName
        switch defect.status {
        case .registered:
            statusBadge.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            statusLabel.textColor = .systemOrange
        case .inProgress:
            statusBadge.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            statusLabel.textColor = .systemBlue
        case .completed:
            statusBadge.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGreen
        }
        
        // Setup priority badge
        priorityLabel.text = defect.priority.displayName
        switch defect.priority {
        case .low:
            priorityBadge.backgroundColor = .systemGray.withAlphaComponent(0.2)
            priorityLabel.textColor = .systemGray
        case .medium:
            priorityBadge.backgroundColor = .systemYellow.withAlphaComponent(0.2)
            priorityLabel.textColor = .systemYellow
        case .high:
            priorityBadge.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            priorityLabel.textColor = .systemOrange
        case .critical:
            priorityBadge.backgroundColor = .systemRed.withAlphaComponent(0.2)
            priorityLabel.textColor = .systemRed
        }
        
        // Format created date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = formatter.date(from: defect.createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd.MM.yyyy"
            createdAtLabel.text = displayFormatter.string(from: date)
        } else {
            createdAtLabel.text = ""
        }
    }
}
