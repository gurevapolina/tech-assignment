import Foundation
import UIKit

struct CountryViewPresentable {
    let navigationItemTitle: String
    let additionalInfoStrings: [NSAttributedString]
}

protocol CountryView: AnyObject {
    func showImage(image: UIImage)
    func updateCountryInfo(presentable: CountryViewPresentable)
}

final class CountryViewController: UIViewController {

    // MARK: Properties

    var presenter: CountryViewPresenter?

    // MARK: Private properties

    private lazy var additionalInfoStackView = createStackView()
    private lazy var flagImageView = createFlagImageView()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(container: view)
        presenter?.countryViewDidLoad(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Building UI

    private func setupUI(container: UIView) {
        view.backgroundColor = .white
        setupStackView(container: view)
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 3
        return label
    }

    private func createFlagImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.flagImageViewCornerRadius
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .center
        return stackView
    }

    private func setupStackView(container: UIView) {
        container.addSubview(additionalInfoStackView)

        NSLayoutConstraint.activate([
            additionalInfoStackView.leftAnchor.constraint(
                equalTo: container.leftAnchor,
                constant: Constants.stackViewLeftSpacing
            ),
            additionalInfoStackView.rightAnchor.constraint(
                equalTo: container.rightAnchor,
                constant: -Constants.stackViewRightSpacing
            ),
            additionalInfoStackView.topAnchor.constraint(
                equalTo: container.safeAreaLayoutGuide.topAnchor,
                constant: Constants.stackViewTopSpacing
            ),
            additionalInfoStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: container.safeAreaLayoutGuide.bottomAnchor
            ),

            flagImageView.widthAnchor.constraint(equalToConstant: Constants.flagImageViewWidth),
            flagImageView.heightAnchor.constraint(equalToConstant: Constants.flagImageViewHeight),
        ])
    }

    // MARK: Constants

    fileprivate struct Constants {
        static let flagImageViewWidth: CGFloat = 200
        static let flagImageViewHeight: CGFloat = 150
        static let flagImageViewCornerRadius: CGFloat = 40
        static let stackViewTopSpacing: CGFloat = 24
        static let stackViewLeftSpacing: CGFloat = 24
        static let stackViewRightSpacing: CGFloat = 24
        static let stackViewSpacing: CGFloat = 8
    }
}

// MARK: CountryView
extension CountryViewController: CountryView {

    func showImage(image: UIImage) {
        DispatchQueue.main.async {
            self.flagImageView.image = image
        }
    }

    func updateCountryInfo(presentable: CountryViewPresentable) {
        navigationItem.title = presentable.navigationItemTitle

        additionalInfoStackView.subviews.forEach({ $0.removeFromSuperview() })
        additionalInfoStackView.addArrangedSubview(flagImageView)

        presentable.additionalInfoStrings.forEach { text in
            let label = createLabel()
            label.attributedText = text
            additionalInfoStackView.addArrangedSubview(label)
        }
    }
}
