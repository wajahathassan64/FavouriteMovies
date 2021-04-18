//
//  FavouriteMovieViewController.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class FavouriteMovieViewController: UIViewController {
    
    // MARK: - Init
    init(viewModel: FavouriteMovieViewModelType) {
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

    // MARK: - Properties
    let viewModel: FavouriteMovieViewModelType
    let disposeBag: DisposeBag
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
        bindTableView()
        addBackButton()
    }
    
    override func onTapBackButton() {
        viewModel.inputs.backObserver.onNext(())
    }
}

// MARK: - Setup
fileprivate extension FavouriteMovieViewController {
    func setup() {
        title = "Favourite Movies"
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .black
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    func setupConstraints() {
        tableView.alignAllEdgesWithSuperview()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

// MARK: - Bind
fileprivate extension FavouriteMovieViewController {
    func bind() {  }
    
    func bindTableView() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })
        
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(MovieTableViewCellViewModel.self)
            .map{ $0.movieResult }
            .bind(to: viewModel.inputs.selectMovieObserver)
            .disposed(by: disposeBag)
    }
}

