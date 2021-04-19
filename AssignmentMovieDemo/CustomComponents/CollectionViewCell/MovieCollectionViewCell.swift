//
//  MovieCollectionViewCell.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import RxSwift
import RxCocoa

class MovieCollectionViewCell: RxUICollectionViewCell {
    
    private var viewModel: MovieCollectionViewCellViewModelType!
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        addActionOnFavouriteIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Configuration
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? MovieCollectionViewCellViewModelType else { return }
        self.viewModel = viewModel
        bind(viewModel: viewModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 4
    }
    
    func addActionOnFavouriteIcon() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteIconTap(tapGestureRecognizer:)))
        favouriteIcon.isUserInteractionEnabled = true
        favouriteIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func favouriteIconTap(tapGestureRecognizer: UITapGestureRecognizer) {
        favouriteIcon.tintColor = .systemPink
        viewModel.inputs.favouriteIconTapObserver.onNext(())
    }
    
}

// MARK: SetupViews
private extension MovieCollectionViewCell {
    func setupViews() {
        contentView.backgroundColor = .clear
        containerView.addSubview(posterImageView)
        containerView.addSubview(movieName)
        containerView.addSubview(favouriteIcon)
        contentView.addSubview(containerView)
    }
    
    func setupConstraints() {
        
        posterImageView
            .alignEdgesWithSuperview([.left, .right, .top])
        
        movieName
            .topToBottom(posterImageView, constant: 4)
            .alignEdgesWithSuperview([.left, .right, .bottom], constants: [4, 4, 0])
            .centerHorizontallyInSuperview()
            .height(constant: 22)
        
        containerView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom])
        
        favouriteIcon
            .height(constant: 24)
            .width(constant: 26)
            .alignEdges([.bottom,. right], withView: posterImageView, constants: [6, 6])
        
    }
    
    func bind(viewModel: MovieCollectionViewCellViewModelType) {
        viewModel.outputs.posterUrl.bind(to: posterImageView.rx.loadImage(true)).disposed(by: disposeBag)
        viewModel.outputs.name.bind(to: movieName.rx.text).disposed(by: disposeBag)
        viewModel.outputs.isFavouriteIcon.subscribe(onNext: {[weak self] isFavourite in
            self?.favouriteIcon.tintColor = isFavourite ? .systemPink : .gray
        }).disposed(by: disposeBag)
    }
}

