//
//  ObjectsViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import UIKit
import Kingfisher

class ObjectsViewController: UIViewController {
    var presenter: ObjectsViewPresenter?
    
    lazy private var labelObjects: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.text = "Список объектов"
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupNavigationBar()
        setupConstraints()
        presenter?.fetchObjects()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = labelObjects
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        // Пустая функция для кнопки "+"
        let vc = AddObjectViewController()
        let presenterVc = AddObjectViewPresenter()
        vc.presenter = presenterVc
        presenterVc.delegate = vc
        vc.delegateForUpdate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ObjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfObjects ?? 0 // Количество секций = количество элементов
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ObjectTableViewCell
        cell?.objectLabel.text = presenter?.getObject(at: indexPath.section).name ?? ""
        ImageService.shared.loadImage(
            for: cell?.objectsImageView ?? UIImageView(),
            from: "http://localhost:8080/api/v1/files/\(presenter?.getObject(at: indexPath.section).id ?? -1)",
            placeholder: UIImage(resource: .mock)
        )
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 8 // Первая секция без отступа сверху
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Возвращаем пустой view для header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? nil : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Или любая нужная высота
    }
    
    // Контекстное меню для каждой ячейки
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", 
                                    image: UIImage(systemName: "pencil")) { action in
                // Здесь будет логика редактирования
                print("Редактировать объект в секции \(indexPath.section)")
            }
            
            let deleteAction = UIAction(title: "Удалить", 
                                      image: UIImage(systemName: "trash"),
                                      attributes: .destructive) { action in
                // Здесь будет логика удаления
                print("Удалить объект в секции \(indexPath.section)")
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let object = presenter?.getObject(at: indexPath.section) else {
            assertionFailure("Не удалось извлечь объект")
            return
        }
        let vc = ObjectViewController(object: object)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ObjectsViewController: ObjectsViewDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}

extension ObjectsViewController: ObjectsViewUpdateDelegate {
    func updateData() {
        presenter?.refreshData()
    }
}
