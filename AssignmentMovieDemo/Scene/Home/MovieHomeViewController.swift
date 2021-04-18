//
//  MovieHomeViewController.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MovieHomeViewController: UIViewController {
    
    // MARK: - Init
    init(viewModel: MovieHomeViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.isDirectionalLockEnabled = true
        return collectionView
    }()   
    
    // MARK: - Properties
    let disposeBag: DisposeBag
    let viewModel: MovieHomeViewModelType
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, ReusableCollectionViewCellViewModelType>>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        setUpNavigationItems()
        viewModel.inputs.loadNextPageObserver.onNext(())
        
    }
    
    func setUpNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_favourite_empty"), style: .plain, target: self, action: #selector(self.favouriteAction(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_search")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.searchAction(_:)))
    }
    
    @objc
    func favouriteAction(_ sender: UIButton) {
        viewModel.inputs.actionFavouriteMoviesObserver.onNext(())
    }
    
    @objc
    func searchAction(_ sender: UIButton) {
        viewModel.inputs.actionSearchMoviesObserver.onNext(())
    }
}

// MARK: - Setup
fileprivate extension MovieHomeViewController {
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        title = "Move Demo"
        view.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
    }
    
    func setupConstraints() {
        collectionView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [6, 6, 0, 0])
    }
}

// MARK: - Bind
fileprivate extension MovieHomeViewController {
    func bind() {
        bindCollectionView()
        viewModel.outputs.error.bind(to: rx.showErrorMessage).disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
        dataSource = RxCollectionViewSectionedReloadDataSource(configureCell: { (_, collectionView, indexPath, viewModel) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reusableIdentifier, for: indexPath) as! RxUICollectionViewCell
            cell.configure(with: viewModel)
            return cell
        })
        
        viewModel.outputs.dataSource.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom(offset: 100).bind(to: viewModel.inputs.loadNextPageObserver).disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(MovieCollectionViewCellViewModel.self)
            .map{ $0.movieResult }
            .bind(to: viewModel.inputs.selectMovieObserver)
            .disposed(by: disposeBag)
    }
}

extension MovieHomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
