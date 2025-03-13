import UIKit

protocol CountriesListView: AnyObject {
    func showCountries(_ countries: [Country])
    func showErrorVisible(_ visible: Bool)
    func showLoadingVisible(_ visible: Bool)
    func showCountryInfoController(_ controller: UIViewController)
}

final class CountriesListViewController: UIViewController {

    // MARK: Properties

    var presenter: CountriesListPresenter?

    // MARK: Private properties

    private lazy var countriesTableView = createTableView()
    private lazy var errorView = createErrorView()
    private lazy var loadingIndicator = createLoadingIndcator()

    private var countries: [Country] = []

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(container: view)
        presenter?.countriesListViewDidLoad(self)
    }

    // MARK: Building UI

    private func setupUI(container: UIView) {
        navigationItem.title = "All countries"
        navigationController?.navigationBar.tintColor = .lightGray

        setupTableView(container: container)
        setupErrorView(container: container)
        setupLoadingIndicator(container: container)
    }

    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(
            CountryTableViewCell.self,
            forCellReuseIdentifier: String(describing: CountryTableViewCell.self)
        )
        return tableView
    }

    private func setupTableView(container: UIView) {
        countriesTableView.delegate = self
        countriesTableView.dataSource = self

        container.addSubview(countriesTableView)

        NSLayoutConstraint.activate([
            countriesTableView.leftAnchor.constraint(equalTo: container.leftAnchor),
            countriesTableView.rightAnchor.constraint(equalTo: container.rightAnchor),
            countriesTableView.topAnchor.constraint(equalTo: container.topAnchor),
            countriesTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }

    private func createErrorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func setupErrorView(container: UIView) {
        container.addSubview(errorView)
        errorView.isHidden = true

        let errorLabel = createErrorLabel()
        errorView.addSubview(errorLabel)

        let tryAgainLabel = createTryAgainLabel()
        errorView.addSubview(tryAgainLabel)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTryAgain))
        tryAgainLabel.addGestureRecognizer(tapGestureRecognizer)

        NSLayoutConstraint.activate([
            errorView.leftAnchor.constraint(equalTo: container.leftAnchor),
            errorView.rightAnchor.constraint(equalTo: container.rightAnchor),
            errorView.topAnchor.constraint(equalTo: container.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: errorView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: errorView.trailingAnchor),

            tryAgainLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            tryAgainLabel.topAnchor.constraint(
                equalTo: errorLabel.bottomAnchor,
                constant: Constants.tryAgainLabelTopSpacing
            ),
            tryAgainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: errorView.leadingAnchor),
            tryAgainLabel.trailingAnchor.constraint(lessThanOrEqualTo: errorView.trailingAnchor),
        ])
    }

    private func createErrorLabel() -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Something went wrong"
        return label
    }

    private func createTryAgainLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "Try again"
        return label
    }

    private func createLoadingIndcator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }

    private func setupLoadingIndicator(container: UIView) {
        loadingIndicator.isHidden = true
        container.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: Constants.loadingIndicatorSize),
            loadingIndicator.heightAnchor.constraint(equalToConstant: Constants.loadingIndicatorSize),
        ])
    }

    // MARK: Actions

    @objc private func didTapTryAgain() {
        presenter?.countriesListViewDidTapTryAgain(self)
    }

    // MARK: Constants

    fileprivate struct Constants {
        static let loadingIndicatorSize: CGFloat = 44
        static let tryAgainLabelTopSpacing: CGFloat = 16
        static let tableViewCellHeght: CGFloat = 56
    }
}

// MARK: CountriesListView
extension CountriesListViewController: CountriesListView {

    func showCountries(_ countries: [Country]) {
        self.countries = countries
        DispatchQueue.main.async {
            self.countriesTableView.reloadData()
        }
    }

    func showErrorVisible(_ visible: Bool) {
        DispatchQueue.main.async {
            self.errorView.isHidden = (visible == false)
        }
    }

    func showLoadingVisible(_ visible: Bool) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = (visible == false)
            self.countriesTableView.isScrollEnabled = (visible == false)
        }
    }

    func showCountryInfoController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CountryTableViewCell.self)
        ) as? CountryTableViewCell else {
            return UITableViewCell()
        }

        let country = countries[indexPath.row]
        cell.update(name: country.name.common)
        return cell
    }
}

// MARK: UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.countriesListViewDidSelectCountry(self, index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewCellHeght
    }
}

