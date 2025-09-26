//
//  ImageServices.swift
//  VersionControl
//
//  Created by Николай Жирнов on 17.09.2025.
//

import UIKit
import Kingfisher

final class ImageService {
    static let shared = ImageService()
    private let tokenStorage = TokenStorage()
    
    private init() {}
    
    @MainActor
    func loadImage(
        for imageView: UIImageView,
        from urlString: String,
        placeholder: UIImage? = UIImage(resource: .logoView) // Добавил дефолтный плейсхолдер
    ) {
        // Устанавливаем плейсхолдер сразу на случай проблем с токеном/URL
        imageView.image = placeholder
        
        guard let token = tokenStorage.token,
              let url = URL(string: urlString) else {
            print("❌ ImageService: No token or invalid URL: \(urlString)")
            return
        }
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return r
        }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .requestModifier(modifier),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { result in
            // Добавим обработку результата для отладки
            switch result {
            case .success(let value):
                print("✅ Image loaded: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("❌ Image loading failed: \(error.localizedDescription)")
                // При ошибке плейсхолдер уже установлен выше
            }
        }
    }
}

