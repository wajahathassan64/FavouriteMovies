//
//  MovieDetailsViewController.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 18/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Init
    init(viewModel: MovieDetailsViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    private lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favouriteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "icon_favourite_pink")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    let disposeBag: DisposeBag
    let viewModel: MovieDetailsViewModelType
    var posterImageViewLeadingContraint: NSLayoutConstraint!
    var favIconContraint: NSLayoutConstraint!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        setup()
        bind()
        addActionOnFavouriteIcon()
        addBackButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        posterImageView.roundView(withBorderColor: .white, withBorderWidth: 1.0)
    }
    
    func addActionOnFavouriteIcon() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteIconTap(tapGestureRecognizer:)))
        favouriteIcon.isUserInteractionEnabled = true
        favouriteIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func favouriteIconTap(tapGestureRecognizer: UITapGestureRecognizer) {
        favouriteIcon.tintColor = .systemPink
        viewModel.inputs.actionFavouriteIcon.onNext(())
    }
    
    override func onTapBackButton() {
        viewModel.inputs.backObserver.onNext(())
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIDevice.current.orientation.isLandscape {
                self.posterImageViewLeadingContraint.constant = 45
                self.favIconContraint.constant = 22
            } else {
                self.posterImageViewLeadingContraint.constant = 10
                self.favIconContraint.constant = 12
            }
        })
    }
}

// MARK: - Setup
fileprivate extension MovieDetailsViewController {
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .black
        containerView.addSubview(posterImageView)
        containerView.addSubview(movieName)
        containerView.addSubview(releaseDate)
        view.addSubview(bannerImageView)
        view.addSubview(containerView)
        view.addSubview(overviewTextView)
        view.addSubview(favouriteIcon)
    }
    
    func setupConstraints() {
        bannerImageView
            .alignEdgesWithSuperview([.left, .right, .safeAreaTop])
            .height(constant: 210)
        
        containerView
            .alignEdge(.bottom, withView: bannerImageView)
            .alignEdgesWithSuperview([.left, .right])
            .height(constant: 80)
        
        
        posterImageViewLeadingContraint = posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        
        let posterImageConstraints = [
            posterImageViewLeadingContraint!,
            posterImageView.heightAnchor.constraint(equalToConstant: 60),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
        ]
        
        posterImageView
            .centerVerticallyInSuperview()
        
        movieName
            .toRightOf(posterImageView, constant: 10)
            .alignEdgeWithSuperview(.top, .lessThanOrEqualTo , constant: 24)
            .alignEdgeWithSuperview(.right, constant: 10)
        
        releaseDate
            .topToBottom(movieName, constant: 4)
            .toRightOf(posterImageView, constant: 10)
            .alignEdgeWithSuperview(.right, constant: 10)
            .alignEdgeWithSuperview(.bottom, .greaterThanOrEqualTo , constant: 6)
        
        favIconContraint = view.trailingAnchor.constraint(equalTo: favouriteIcon.trailingAnchor, constant: 12)
        
        favouriteIcon
            .height(constant: 22)
            .width(constant: 24)
            .alignEdges([.bottom], withView: containerView, constants: [8])
        
        overviewTextView
            .topToBottom(bannerImageView)
            .alignEdgesWithSuperview([.left, .right , .safeAreaBottom])
        
        NSLayoutConstraint.activate(posterImageConstraints + [favIconContraint])
    }
}

// MARK: - Bind
fileprivate extension MovieDetailsViewController {
    func bind() {
        viewModel.outputs.movieTitle.bind(to: movieName.rx.text).disposed(by: disposeBag)
        viewModel.outputs.movieReleaseDate.bind(to: releaseDate.rx.text).disposed(by: disposeBag)
        viewModel.outputs.movieOverview.bind(to: overviewTextView.rx.text).disposed(by: disposeBag)
        viewModel.outputs.coverImage.unwrap().bind(to: bannerImageView.rx.loadImage(true)).disposed(by: disposeBag)
        viewModel.outputs.posterImage.unwrap().bind(to: posterImageView.rx.loadImage(true)).disposed(by: disposeBag)
        viewModel.outputs.isFavouriteIcon.subscribe(onNext: {[weak self] isFavourite in
            self?.favouriteIcon.tintColor = isFavourite ? .systemPink : .gray
        }).disposed(by: disposeBag)
    }
}

