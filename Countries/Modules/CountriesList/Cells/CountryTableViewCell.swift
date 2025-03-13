import Foundation
import UIKit

final class CountryTableViewCell: UITableViewCell {

    // MARK: Private properties

    private lazy var nameLabel = createLabel()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI(container: contentView)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    // MARK: Methods

    func update(name: String) {
        nameLabel.text = name
    }

    // MARK: Building UI

    private func setupUI(container: UIView) {
        setupNameLabel(container: container)
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }

    private func setupNameLabel(container: UIView) {
        container.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: Constants.labelLeftSpacing
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -Constants.labelRightSpacing
            ),
        ])
    }

    // MARK: Constants

    fileprivate struct Constants {
        static let labelLeftSpacing: CGFloat = 16
        static let labelRightSpacing: CGFloat = 16
    }
}
