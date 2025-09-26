//
//  ObjectTableViewCell.swift
//  VersionControl
//
//  Created by Николай Жирнов on 13.09.2025.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {
    private lazy var objectView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var objectsImageView: UIImageView = {
        let imageView = UIImageView() // UIImageView(image: UIImage(resource: .mock))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var objectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Дом"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(objectView)
        objectView.addSubview(objectsImageView)
        objectView.addSubview(objectLabel)
        
        NSLayoutConstraint.activate([
            objectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            objectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            objectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            objectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            objectsImageView.topAnchor.constraint(greaterThanOrEqualTo: objectView.topAnchor),
            objectsImageView.bottomAnchor.constraint(lessThanOrEqualTo: objectView.bottomAnchor, constant: -40),
            objectsImageView.leadingAnchor.constraint(greaterThanOrEqualTo: objectView.leadingAnchor),
            objectsImageView.trailingAnchor.constraint(lessThanOrEqualTo: objectView.trailingAnchor),
            
            objectLabel.topAnchor.constraint(equalTo: objectsImageView.bottomAnchor, constant: 8),
            objectLabel.leadingAnchor.constraint(equalTo: objectView.leadingAnchor, constant: 8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
