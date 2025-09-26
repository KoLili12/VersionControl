//
//  AddObjectViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 18.09.2025.
//

import UIKit
import ProgressHUD

class AddObjectViewController: UIViewController {
    
    var presenter: AddObjectViewPresenter?
    var delegateForUpdate: ObjectsViewUpdateDelegate?
    
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
    
    private lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Выбрать фото", for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.addTarget(self, action: #selector(didTapImagePickerButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = createTextField(placeholder: "Название объекта")
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.systemGray6
        textView.layer.cornerRadius = 12
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.isScrollEnabled = false
        textView.text = "Описание объекта"
        textView.textColor = .systemGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = createTextField(placeholder: "Адрес")
        return textField
    }()
    
    private lazy var statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выберите статус", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStatusSelection), for: .touchUpInside)
        return button
    }()
    
    private lazy var startDateButton: UIButton = {
        let button = createDateButton(title: "Дата начала")
        button.addTarget(self, action: #selector(selectStartDate), for: .touchUpInside)
        return button
    }()
    
    private lazy var endDateButton: UIButton = {
        let button = createDateButton(title: "Дата окончания")
        button.addTarget(self, action: #selector(selectEndDate), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var selectedStatus: String?
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    private let statusOptions = ["active", "completed", "paused", "cancelled"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Добавить объект"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(addressTextField)
        contentView.addSubview(statusButton)
        contentView.addSubview(startDateButton)
        contentView.addSubview(endDateButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(imagePickerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // ImagePickerButton
            
            imagePickerButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imagePickerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagePickerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagePickerButton.heightAnchor.constraint(equalToConstant: 150),
            
            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description TextView
            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            // Address TextField
            addressTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Status Button
            statusButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Start Date Button
            startDateButton.topAnchor.constraint(equalTo: statusButton.bottomAnchor, constant: 16),
            startDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            startDateButton.heightAnchor.constraint(equalToConstant: 44),
            
            // End Date Button
            endDateButton.topAnchor.constraint(equalTo: startDateButton.bottomAnchor, constant: 16),
            endDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            endDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            endDateButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: endDateButton.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Helper Methods
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 16)
        
        // Отступы внутри поля
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return textField
    }
    
    private func createDateButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard
            let name = nameTextField.text,
            let description = descriptionTextView.text,
            let address = addressTextField.text,
            let selectedStartDate,
            let selectedEndDate
        else { return }
        let object = ObjectForRequest(
            name: name,
            description: description,
            address: address,
            startDate: ISO8601DateFormatter().string(from: selectedStartDate),
            endDate: ISO8601DateFormatter().string(from: selectedEndDate)
        )
        
        ProgressHUD.animate()
        
        let photoData = imagePickerButton.imageView?.image?.pngData()
            presenter?.addObject(object: object, photo: photoData)
    }
    
    @objc private func showStatusSelection() {
        let alert = UIAlertController(title: "Выберите статус", message: nil, preferredStyle: .actionSheet)
        
        let statusDisplayNames = [
            "active": "Активный",
            "completed": "Завершен",
            "paused": "Приостановлен",
            "cancelled": "Отменен"
        ]
        
        for status in statusOptions {
            let displayName = statusDisplayNames[status] ?? status
            let action = UIAlertAction(title: displayName, style: .default) { _ in
                self.selectedStatus = status
                self.statusButton.setTitle(displayName, for: .normal)
                self.statusButton.setTitleColor(.label, for: .normal)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = statusButton
            popover.sourceRect = statusButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func selectStartDate() {
        showDatePicker(for: .start)
    }
    
    @objc private func selectEndDate() {
        showDatePicker(for: .end)
    }
    
    @objc private func didTapImagePickerButton() {
        showImagePickerControllerActionSheet()
    }
    
    private enum DateType {
        case start, end
    }
    
    private func showDatePicker(for dateType: DateType) {
        let alertController = UIAlertController(title: dateType == .start ? "Выберите дату начала" : "Выберите дату окончания", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Создаем контейнер для date picker
        let pickerViewController = UIViewController()
        pickerViewController.preferredContentSize = CGSize(width: 320, height: 220)
        pickerViewController.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: pickerViewController.view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: pickerViewController.view.centerYAnchor),
            datePicker.leadingAnchor.constraint(greaterThanOrEqualTo: pickerViewController.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(lessThanOrEqualTo: pickerViewController.view.trailingAnchor)
        ])
        
        alertController.setValue(pickerViewController, forKey: "contentViewController")
        
        alertController.addAction(UIAlertAction(title: "Выбрать", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ru_RU")
            
            if dateType == .start {
                self.selectedStartDate = datePicker.date
                self.startDateButton.setTitle("Начало: \(formatter.string(from: datePicker.date))", for: .normal)
                self.startDateButton.setTitleColor(.label, for: .normal)
            } else {
                self.selectedEndDate = datePicker.date
                self.endDateButton.setTitle("Окончание: \(formatter.string(from: datePicker.date))", for: .normal)
                self.endDateButton.setTitleColor(.label, for: .normal)
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alertController, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension AddObjectViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Описание объекта"
            textView.textColor = .systemGray
        }
    }
}

extension AddObjectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let alert = UIAlertController(title: "Выбирете изображение", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Выбрать из галерии", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Сделать фото с камеры", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickerButton.setImage(image, for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerButton.setImage(originalImage, for: .normal)
        }
        imagePickerButton.setTitle(nil, for: .normal)
        dismiss(animated: true)
    }
}

extension AddObjectViewController: AddObjectDelegate {
    func objectDidAdd() {
        ProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
        delegateForUpdate?.updateData()
    }
}
