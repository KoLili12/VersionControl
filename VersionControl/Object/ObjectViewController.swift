//
//  ObjectViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 29.09.2025.
//

import UIKit
import Kingfisher
import Combine
import Foundation

class ObjectViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    var presenter: ObjectViewPresenter?
    
    private var object: Object
    
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
    
    // MARK: - Info Cards
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var addressCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var addressIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var datesCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var datesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var startDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var startDateIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var endDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var endDateIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "stop.circle.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var creatorCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var creatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var creatorIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Defects Section
    private lazy var defectsSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var defectsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.text = "Дефекты"
        return label
    }()
    
    private lazy var viewAllDefectsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Смотреть все", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var defectsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(DefectTableViewCell.self, forCellReuseIdentifier: DefectTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var noDefectsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.text = "Дефектов не найдено"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // Массив для хранения дефектов
    private var defects: [Defect] = []
    
    // MARK: - Initialization
    init(object: Object) {
        self.object = object
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupBindings()
        presenter?.fetchDefects(idObject: object.id)
    }
    
    private func setupBindings() {
        presenter?.$defects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] defects in
                self?.defects = Array(defects.prefix(10)) // Показываем только первые 10 дефектов
                self?.updateDefectsUI()
            }
            .store(in: &cancellables)
        
        presenter?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // Показать/скрыть индикатор загрузки
                print("Loading: \(isLoading)")
            }
            .store(in: &cancellables)
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
        contentView.addSubview(infoStackView)
        contentView.addSubview(defectsSectionView)
        
        // Setup info cards
        setupInfoCards()
        
        // Добавляем элементы секции дефектов
        defectsSectionView.addSubview(defectsTitleLabel)
        defectsSectionView.addSubview(viewAllDefectsButton)
        defectsSectionView.addSubview(defectsTableView)
        defectsSectionView.addSubview(noDefectsLabel)
    }
    
    private func setupInfoCards() {
        // Address Card
        infoStackView.addArrangedSubview(addressCardView)
        addressCardView.addSubview(addressStackView)
        addressStackView.addArrangedSubview(addressIconView)
        addressStackView.addArrangedSubview(addressLabel)
        
        // Dates Card
        infoStackView.addArrangedSubview(datesCardView)
        datesCardView.addSubview(datesStackView)
        datesStackView.addArrangedSubview(startDateStackView)
        datesStackView.addArrangedSubview(endDateStackView)
        
        startDateStackView.addArrangedSubview(startDateIconView)
        startDateStackView.addArrangedSubview(startDateLabel)
        
        endDateStackView.addArrangedSubview(endDateIconView)
        endDateStackView.addArrangedSubview(endDateLabel)
        
        // Creator Card
        infoStackView.addArrangedSubview(creatorCardView)
        creatorCardView.addSubview(creatorStackView)
        creatorStackView.addArrangedSubview(creatorIconView)
        creatorStackView.addArrangedSubview(creatorLabel)
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
            
            // Info Stack View
            infoStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Address Card constraints
            addressStackView.topAnchor.constraint(equalTo: addressCardView.topAnchor, constant: 16),
            addressStackView.leadingAnchor.constraint(equalTo: addressCardView.leadingAnchor, constant: 16),
            addressStackView.trailingAnchor.constraint(equalTo: addressCardView.trailingAnchor, constant: -16),
            addressStackView.bottomAnchor.constraint(equalTo: addressCardView.bottomAnchor, constant: -16),
            
            addressIconView.widthAnchor.constraint(equalToConstant: 24),
            addressIconView.heightAnchor.constraint(equalToConstant: 24),
            
            // Dates Card constraints
            datesStackView.topAnchor.constraint(equalTo: datesCardView.topAnchor, constant: 16),
            datesStackView.leadingAnchor.constraint(equalTo: datesCardView.leadingAnchor, constant: 16),
            datesStackView.trailingAnchor.constraint(equalTo: datesCardView.trailingAnchor, constant: -16),
            datesStackView.bottomAnchor.constraint(equalTo: datesCardView.bottomAnchor, constant: -16),
            
            startDateIconView.widthAnchor.constraint(equalToConstant: 24),
            startDateIconView.heightAnchor.constraint(equalToConstant: 24),
            endDateIconView.widthAnchor.constraint(equalToConstant: 24),
            endDateIconView.heightAnchor.constraint(equalToConstant: 24),
            
            // Creator Card constraints
            creatorStackView.topAnchor.constraint(equalTo: creatorCardView.topAnchor, constant: 16),
            creatorStackView.leadingAnchor.constraint(equalTo: creatorCardView.leadingAnchor, constant: 16),
            creatorStackView.trailingAnchor.constraint(equalTo: creatorCardView.trailingAnchor, constant: -16),
            creatorStackView.bottomAnchor.constraint(equalTo: creatorCardView.bottomAnchor, constant: -16),
            
            creatorIconView.widthAnchor.constraint(equalToConstant: 24),
            creatorIconView.heightAnchor.constraint(equalToConstant: 24),
            
            // Defects Section
            defectsSectionView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 24),
            defectsSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            defectsSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            defectsSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Defects Title
            defectsTitleLabel.topAnchor.constraint(equalTo: defectsSectionView.topAnchor, constant: 16),
            defectsTitleLabel.leadingAnchor.constraint(equalTo: defectsSectionView.leadingAnchor, constant: 16),
            
            // View All Button
            viewAllDefectsButton.centerYAnchor.constraint(equalTo: defectsTitleLabel.centerYAnchor),
            viewAllDefectsButton.trailingAnchor.constraint(equalTo: defectsSectionView.trailingAnchor, constant: -16),
            viewAllDefectsButton.leadingAnchor.constraint(greaterThanOrEqualTo: defectsTitleLabel.trailingAnchor, constant: 8),
            
            // Defects Table View
            defectsTableView.topAnchor.constraint(equalTo: defectsTitleLabel.bottomAnchor, constant: 12),
            defectsTableView.leadingAnchor.constraint(equalTo: defectsSectionView.leadingAnchor),
            defectsTableView.trailingAnchor.constraint(equalTo: defectsSectionView.trailingAnchor),
            defectsTableView.bottomAnchor.constraint(equalTo: defectsSectionView.bottomAnchor, constant: -16),
            
            // No Defects Label
            noDefectsLabel.centerXAnchor.constraint(equalTo: defectsSectionView.centerXAnchor),
            noDefectsLabel.centerYAnchor.constraint(equalTo: defectsTableView.centerYAnchor),
            noDefectsLabel.leadingAnchor.constraint(equalTo: defectsSectionView.leadingAnchor, constant: 16),
            noDefectsLabel.trailingAnchor.constraint(equalTo: defectsSectionView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupData() {
        // Setup object data
        nameLabel.text = object.name
        descriptionLabel.text = object.description
        addressLabel.text = object.address
        
        // Setup status
        setupStatusBadge()
        
        // Setup formatted dates
        startDateLabel.text = "Начало: \(formatDate(object.startDate))"
        endDateLabel.text = "Окончание: \(formatDate(object.endDate))"
        
        // Setup creator
        let creator = object.creator
        creatorLabel.text = "\(creator.firstName) \(creator.lastName)"
        
        // Load object image with ImageService
        loadObjectImage()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // Fallback для других форматов
        let alternativeFormatter = DateFormatter()
        alternativeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = alternativeFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // Если не удалось распарсить, возвращаем исходную строку
        return dateString
    }
    
    private func updateDefectsUI() {
        if defects.isEmpty {
            defectsTableView.isHidden = true
            noDefectsLabel.isHidden = false
        } else {
            defectsTableView.isHidden = false
            noDefectsLabel.isHidden = true
            defectsTableView.reloadData()
            
            // Обновляем высоту таблицы в зависимости от количества дефектов
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let cellHeight: CGFloat = 110
                let tableHeight = CGFloat(self.defects.count) * cellHeight
                
                // Удаляем старое ограничение высоты, если оно есть
                self.defectsTableView.constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.isActive = false
                    }
                }
                
                // Добавляем новое ограничение высоты
                self.defectsTableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
                
                // Обновляем layout
                self.view.layoutIfNeeded()
            }
        }
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
            from: "http://localhost:8080/api/v1/projects/\(object.id)/image",
            placeholder: UIImage(systemName: "photo")
        )
    }
}

// MARK: - UITableViewDataSource
extension ObjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefectTableViewCell.identifier, for: indexPath) as? DefectTableViewCell else {
            return UITableViewCell()
        }
        
        let defect = defects[indexPath.row]
        cell.configure(with: defect)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ObjectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Здесь можно добавить навигацию к детальному экрану дефекта
        let defect = defects[indexPath.row]
        print("Selected defect: \(defect.title)")
    }
}

