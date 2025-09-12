import UIKit

final class PresentationViewController: UIViewController {
    
    private lazy var presentationLabel: UILabel = {
        let view = UILabel()
        view.text = "Добро пожаловать в приложение Контроль Версий"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Начать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(presentationLabel)
        view.addSubview(startButton)
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            presentationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            presentationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            presentationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: presentationLabel.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func startButtonTapped() {
        let vc = LoginViewController()
        let presenter = LoginViewPresenter()
        vc.presenter = presenter
        presenter.delegate = vc
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

