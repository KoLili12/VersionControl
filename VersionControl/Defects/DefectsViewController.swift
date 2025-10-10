//
//  DefectsViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 05.10.2025.
//

import UIKit
import Combine

class DefectsViewController: UIViewController {
    
    var presenter: ObjectViewPresenter?
    private var cancellables = Set<AnyCancellable>()
    
    // Filtered defects for display
    private var filteredDefects: [Defect] = []
    private var selectedStatusFilter: DefectStatus?
    private var selectedPriorityFilter: DefectPriority?
    private var searchText: String = ""
    
    // MARK: - UI Elements
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск дефектов..."
        return searchController
    }()
    
    private lazy var filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var clearFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сбросить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(clearFiltersButtonTapped), for: .touchUpInside)
        
        // Устанавливаем красно-белый стиль
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.register(DefectTableViewCell.self, forCellReuseIdentifier: DefectTableViewCell.identifier)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дефекты не найдены"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Попробуйте изменить параметры поиска или создать новый дефект"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Все дефекты"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        setupFilterButtons()
        setupLayout()
    }
    
    private func setupFilterButtons() {
        // Status filters
        let allStatusButton = createFilterButton(title: "Все", isSelected: true)
        allStatusButton.tag = -1 // Специальный тег для кнопки "Все"
        allStatusButton.addTarget(self, action: #selector(allStatusFilterTapped), for: .touchUpInside)
        filterStackView.addArrangedSubview(allStatusButton)
        
        // Используем порядковый номер для тегов статусов
        for (index, status) in DefectStatus.allCases.enumerated() {
            let button = createFilterButton(title: status.displayName)
            button.tag = index // 0, 1, 2
            button.addTarget(self, action: #selector(statusFilterTapped(_:)), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
        }
        
        // Add separator
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        filterStackView.addArrangedSubview(separator)
        
        // Priority filters - используем порядковый номер + 100 для избежания конфликтов
        for (index, priority) in DefectPriority.allCases.enumerated() {
            let button = createFilterButton(title: priority.displayName)
            button.tag = index + 100 // 100, 101, 102, 103
            button.addTarget(self, action: #selector(priorityFilterTapped(_:)), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
        }
        
        // Add clear filters button
        filterStackView.addArrangedSubview(clearFiltersButton)
    }
    
    private func createFilterButton(title: String, isSelected: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        updateFilterButton(button, isSelected: isSelected)
        
        return button
    }
    
    private func updateFilterButton(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0
        } else {
            button.backgroundColor = .secondarySystemBackground
            button.setTitleColor(.label, for: .normal)
            button.layer.borderColor = UIColor.separator.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    private func setupLayout() {
        view.addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
        view.addSubview(tableView)
        
        // Empty state
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        
        NSLayoutConstraint.activate([
            // Filter ScrollView
            filterScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 60),
            
            // Filter StackView
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor, constant: 12),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: -12),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor, constant: -24),
            
            // TableView
            tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -40),
            
            // Empty Image
            emptyImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Empty Title
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            emptyTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            // Empty Subtitle
            emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 8),
            emptySubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptySubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        presenter?.$defects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        presenter?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Data should already be loaded by ObjectViewPresenter
        applyFilters()
    }
    
    // MARK: - Filtering
    private func applyFilters() {
        guard let presenter = presenter else { return }
        
        filteredDefects = presenter.defects.filter { defect in
            var matches = true
            
            // Status filter
            if let selectedStatus = selectedStatusFilter {
                matches = matches && defect.status == selectedStatus
            }
            
            // Priority filter
            if let selectedPriority = selectedPriorityFilter {
                matches = matches && defect.priority == selectedPriority
            }
            
            // Search text filter
            if !searchText.isEmpty {
                matches = matches && (
                    defect.title.localizedCaseInsensitiveContains(searchText) ||
                    defect.description.localizedCaseInsensitiveContains(searchText) ||
                    defect.creator.fullName.localizedCaseInsensitiveContains(searchText)
                )
            }
            
            return matches
        }
        
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        let isEmpty = filteredDefects.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        // TODO: Implement add defect functionality
        let alert = UIAlertController(
            title: "Добавить дефект",
            message: "Функционал добавления дефекта будет реализован позже",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        // Reload data from presenter if needed
        // For now, just end refreshing since data is already managed by presenter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func allStatusFilterTapped() {
        // Сброс всех фильтров при выборе "Все"
        selectedStatusFilter = nil
        selectedPriorityFilter = nil
        updateFilterButtons()
        applyFilters()
    }
    
    @objc private func statusFilterTapped(_ sender: UIButton) {
        // Получаем статус по индексу
        guard sender.tag >= 0 && sender.tag < DefectStatus.allCases.count else { return }
        let status = DefectStatus.allCases[sender.tag]
        
        // Сброс приоритета и установка нового статуса
        selectedPriorityFilter = nil
        selectedStatusFilter = status
        updateFilterButtons()
        applyFilters()
    }
    
    @objc private func priorityFilterTapped(_ sender: UIButton) {
        // Получаем приоритет по индексу (вычитаем 100)
        let index = sender.tag - 100
        guard index >= 0 && index < DefectPriority.allCases.count else { return }
        let priority = DefectPriority.allCases[index]
        
        // Сброс статуса и установка нового приоритета
        selectedStatusFilter = nil
        selectedPriorityFilter = priority
        updateFilterButtons()
        applyFilters()
    }
    
    @objc private func clearFiltersButtonTapped() {
        selectedStatusFilter = nil
        selectedPriorityFilter = nil
        searchController.searchBar.text = ""
        searchText = ""
        updateFilterButtons()
        
        // Восстанавливаем красно-белый стиль кнопки "Сбросить"
        clearFiltersButton.setTitleColor(.systemRed, for: .normal)
        clearFiltersButton.backgroundColor = .systemBackground
        clearFiltersButton.layer.borderColor = UIColor.systemRed.cgColor
        clearFiltersButton.layer.borderWidth = 1
        
        applyFilters()
    }
    
    private func updateFilterButtons() {
        for subview in filterStackView.arrangedSubviews {
            guard let button = subview as? UIButton else { continue }
            
            var isSelected = false
            
            // Проверяем кнопку "Все" (тег -1)
            if button.tag == -1 {
                isSelected = (selectedStatusFilter == nil && selectedPriorityFilter == nil)
            }
            // Проверяем кнопки статуса (теги 0, 1, 2)
            else if button.tag >= 0 && button.tag < DefectStatus.allCases.count {
                let status = DefectStatus.allCases[button.tag]
                isSelected = selectedStatusFilter == status
            }
            // Проверяем кнопки приоритета (теги 100, 101, 102, 103)
            else if button.tag >= 100 {
                let index = button.tag - 100
                if index >= 0 && index < DefectPriority.allCases.count {
                    let priority = DefectPriority.allCases[index]
                    isSelected = selectedPriorityFilter == priority
                }
            }
            
            updateFilterButton(button, isSelected: isSelected)
        }
    }
}

// MARK: - UITableViewDataSource
extension DefectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDefects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefectTableViewCell.identifier, for: indexPath) as? DefectTableViewCell else {
            return UITableViewCell()
        }
        
        let defect = filteredDefects[indexPath.row]
        cell.configure(with: defect)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DefectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let defect = filteredDefects[indexPath.row]
        
        // TODO: Navigate to defect detail screen
        let alert = UIAlertController(
            title: defect.title,
            message: "Переход к детальному просмотру дефекта будет реализован позже",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension DefectsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        applyFilters()
    }
}
