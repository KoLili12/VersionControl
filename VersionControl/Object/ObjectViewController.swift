//
//  ObjectViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 29.09.2025.
//

import UIKit
import Kingfisher

// MARK: - Defect Model (Mock)
struct Defect {
    let id: Int
    let author: String
    let text: String
    let date: Date
    let avatarURL: String?
}

class ObjectViewController: UIViewController {
    
    private var object: Object
    private var mockDefects: [Defect] = []
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var objectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var statusBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var datesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private lazy var defectsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.text = "Дефекты"
        return label
    }()
    
    private lazy var addDefectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить комментарий", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addDefectTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var defectsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initialization
    init(object: Object) {
        self.object = object
        super.init(nibName: nil, bundle: nil)
        generateMockDefects()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Детали объекта"
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupScrollView()
        setupContentView()
        setupConstraints()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupContentView() {
        contentView.addSubview(objectImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(datesLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(defectsHeaderLabel)
        contentView.addSubview(addDefectButton)
        contentView.addSubview(defectsStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Object Image
            objectImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            objectImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            objectImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            objectImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: objectImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            // Status Badge
            statusBadge.centerYAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            // Status Label
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: -4),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Address Label
            addressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Dates Label
            datesLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            datesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Creator Label
            creatorLabel.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 12),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Defects Header
            defectsHeaderLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 32),
            defectsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            defectsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Add Defect Button
            addDefectButton.topAnchor.constraint(equalTo: defectsHeaderLabel.bottomAnchor, constant: 16),
            addDefectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addDefectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addDefectButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Defects Stack View
            defectsStackView.topAnchor.constraint(equalTo: addDefectButton.bottomAnchor, constant: 16),
            defectsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            defectsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            defectsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupData() {
        // Setup object data
        nameLabel.text = object.name
        descriptionLabel.text = object.description
        addressLabel.text = "📍 \(object.address)"
        
        // Setup status
        setupStatusBadge()
        
        // Setup dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datesLabel.text = "📅 Начало: \(object.startDate)\n📅 Окончание: \(object.endDate)"
        
        // Setup creator
        let creator = object.creator
        creatorLabel.text = "👤 Создатель: \(creator.firstName) \(creator.lastName)"
        
        // Load object image with ImageService
        loadObjectImage()
        
        // Setup defects
        setupDefects()
    }
    
    private func setupStatusBadge() {
        statusLabel.text = object.status.uppercased()
        
        switch object.status.lowercased() {
        case "active", "активный":
            statusBadge.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGreen
        case "completed", "завершен":
            statusBadge.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            statusLabel.textColor = .systemBlue
        case "pending", "ожидание":
            statusBadge.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            statusLabel.textColor = .systemOrange
        case "cancelled", "отменен":
            statusBadge.backgroundColor = .systemRed.withAlphaComponent(0.2)
            statusLabel.textColor = .systemRed
        default:
            statusBadge.backgroundColor = .systemGray.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGray
        }
    }
    
    private func loadObjectImage() {
        ImageService.shared.loadImage(
            for: objectImageView,
            from: "http://localhost:8080/api/v1/files/\(object.id)",
            placeholder: UIImage(systemName: "photo")
        )
    }
    
    private func generateMockDefects() {
        let mockAuthors = ["Иван Петров", "Мария Сидорова", "Алексей Козлов", "Елена Смирнова", "Дмитрий Волков"]
        let mockTexts = [
            "Обнаружена трещина в стене на втором этаже.",
            "Некачественная покраска в комнате №15.",
            "Неровности на полу в коридоре.",
            "Проблемы с электропроводкой в левом крыле.",
            "Протечка в потолке главного холла.",
            "Дефект штукатурки на внешней стене здания."
        ]
        
        mockDefects = (1...5).map { index in
            Defect(
                id: index,
                author: mockAuthors.randomElement() ?? "Аноним",
                text: mockTexts.randomElement() ?? "Дефект",
                date: Date().addingTimeInterval(-Double.random(in: 0...7*24*60*60)), // Last week
                avatarURL: nil
            )
        }.sorted { $0.date > $1.date }
    }
    
    private func setupDefects() {
        // Clear existing defects
        defectsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add mock defects
        for defect in mockDefects {
            let defectView = createDefectView(for: defect)
            defectsStackView.addArrangedSubview(defectView)
        }
    }
    
    private func createDefectView(for defect: Defect) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemRed.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .label
        authorLabel.text = defect.author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: defect.date)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.textColor = .label
        textLabel.numberOfLines = 0
        textLabel.text = defect.text
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add defect icon
        let defectIcon = UILabel()
        defectIcon.text = "⚠️"
        defectIcon.font = .systemFont(ofSize: 16)
        defectIcon.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(defectIcon)
        containerView.addSubview(authorLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            defectIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            defectIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: defectIcon.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            textLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: defectIcon.trailingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    @objc private func addDefectTapped() {
        let alert = UIAlertController(title: "Добавить комментарий", message: "Опишите обнаруженный дефект", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Описание дефекта..."
            textField.autocapitalizationType = .sentences
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty else { return }
            
            self?.addNewDefect(text: text)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func addNewDefect(text: String) {
        let newDefect = Defect(
            id: mockDefects.count + 1,
            author: "Текущий пользователь", // Replace with actual current user
            text: text,
            date: Date(),
            avatarURL: nil
        )
        
        mockDefects.insert(newDefect, at: 0) // Add to the beginning
        
        // Add new defect view to the beginning of the stack
        let defectView = createDefectView(for: newDefect)
        defectsStackView.insertArrangedSubview(defectView, at: 0)
        
        // Animate the addition
        defectView.alpha = 0
        defectView.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.3) {
            defectView.alpha = 1
            defectView.transform = .identity
        }
        
        // Scroll to show the new defect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.scrollRectToVisible(defectView.frame, animated: true)
        }
    }
}
