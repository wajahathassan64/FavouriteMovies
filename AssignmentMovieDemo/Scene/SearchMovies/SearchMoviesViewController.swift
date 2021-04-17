//
//  SearchMoviesViewController.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchMoviesViewController: KeyboardAvoidingViewController {
    
    // MARK: - Init
    init(viewModel: SearchMoviesViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchBar: AppSearchTextField = {
        let textField = AppSearchTextField()
        textField.returnKeyType = .search
        textField.borderStyle = .none
        textField.textColor = .white
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.35)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.layer.cornerRadius = 17.5
        textField.attributedPlaceholder =
        NSAttributedString(string: "Search",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.clipsToBounds = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchStack = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 10, arrangedSubviews: [searchBar, cancelButton])
    
    
    // MARK: - Properties
    let viewModel: SearchMoviesViewModelType
    let disposeBag: DisposeBag
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Movies"
        setup()
        bind()
        bindTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.searchBar.becomeFirstResponder() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Setup
fileprivate extension SearchMoviesViewController {
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .black
        view.addSubview(searchStack)
        view.addSubview(tableView)
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.register(NoSearchResultCell.self, forCellReuseIdentifier: NoSearchResultCell.reuseIdentifier)
    }
    
    func setupConstraints() {
        
        searchStack
            .alignEdgesWithSuperview([.left, .top, .right], constants: [25, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ) + 15, 25])
        
        searchBar
            .height(constant: 35)
            .alignEdgeWithSuperview(.bottom, constant: 10)
        
        cancelButton
            .width(constant: 50)
        
        tableView
            .topToBottom(searchStack)
            .alignEdgesWithSuperview([.left, .right])
            .alignEdgeWithSuperviewSafeArea(.bottomAvoidingKeyboard)
        
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Bind
fileprivate extension SearchMoviesViewController {
    func bind() {
        
        searchBar.rx.text.bind(to: viewModel.inputs.searchInputTextObserver).disposed(by: disposeBag)
        cancelButton.rx.tap
            .do(onNext: { [weak self] in self?.view.endEditing(true) })
            .bind(to: viewModel.inputs.cancelObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.error.bind(to: rx.showErrorMessage).disposed(by: disposeBag)
        
//        viewModel.outputs.reloadMovieData.subscribe(onNext: {[weak self] _ in
//            self?.tableView.reloadData()
//        }).disposed(by: disposeBag)
    }
    func bindTableView() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })
        
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.reachedBottom().bind(to: viewModel.inputs.loadNextPageObserver).disposed(by: disposeBag)
        tableView.rx.modelSelected(MovieTableViewCellViewModelViewModel.self)
            .do(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
                self?.view.endEditing(true)
            })
            .map { $0.movieResult }
            .bind(to: viewModel.inputs.selectMovieObserver)
            .disposed(by: disposeBag)
        
    }
}

