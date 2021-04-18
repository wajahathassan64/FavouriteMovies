//
//  MovieTableViewCell.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieTableViewCell: RxUITableViewCell {
    
    private var viewModel: MovieTableViewCellViewModelType!
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
        addActionOnFavouriteIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Configuration
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? MovieTableViewCellViewModelType else { return }
        self.viewModel = viewModel
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 4
       
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
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
        viewModel.inputs.favouriteIconTapObserver.onNext(())
    }
    
    
}

// MARK: SetupViews
private extension MovieTableViewCell {
    func setupViews() {
        contentView.backgroundColor = .black
        containerView.addSubview(posterImageView)
        containerView.addSubview(movieName)
        containerView.addSubview(releaseDate)
        containerView.addSubview(favouriteIcon)
        contentView.addSubview(containerView)
    }
    
    func setupConstraints() {
        
        containerView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [10,10, 0, 10])
        
        posterImageView
            .alignEdgesWithSuperview([.left, .top, .bottom], constant: 10)
            .width(constant: 80)
            .height(constant: 80)
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
        
        favouriteIcon
            .height(constant: 22)
            .width(constant: 24)
            .alignEdges([.bottom,. right], withView: containerView, constants: [8, 12])
        
    }
    
}

// MARK: Binding
private extension MovieTableViewCell {
    func bind() {
        viewModel.outputs.posterUrl.unwrap().bind(to: posterImageView.rx.loadImage(true)).disposed(by: disposeBag)
        viewModel.outputs.name.bind(to: movieName.rx.text).disposed(by: disposeBag)
        viewModel.outputs.releaseDate.bind(to: releaseDate.rx.text).disposed(by: disposeBag)
        viewModel.outputs.isFavouriteIcon.subscribe(onNext: {[weak self] isFavourite in
            self?.favouriteIcon.tintColor = isFavourite ? .systemPink : .gray
        }).disposed(by: disposeBag)
    }
}
