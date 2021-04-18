//
//  SearchHistoryTableViewCell.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 18/04/2021.
//

import Foundation
import RxSwift

class SearchHistoryTableViewCell: RxUITableViewCell {
    
    // MARK: Views
    
    private lazy var heading: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Search history"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconHistory: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "icon_history")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .fill, distribution: .fill, spacing: 10, arrangedSubviews: [heading, containerView])
    
    // MARK: Properties
    private var viewModel: SearchHistoryTableViewCellViewModelType!
    
    // MARK: Initialization
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: Configurations
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? SearchHistoryTableViewCellViewModelType else { return }
        self.viewModel = viewModel
        bindView(with: viewModel)
    }
}

// MARK: View setup

private extension SearchHistoryTableViewCell {
    func setupViews() {
        backgroundColor = .black
        containerView.addSubview(iconHistory)
        containerView.addSubview(title)
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [15, 10, 0, 10])
        
        iconHistory
            .width(constant: 22)
            .height(constant: 22)
            .centerVerticallyInSuperview()
            .alignEdgeWithSuperview(.left, constant: 10)
        
        title
            .centerVerticallyInSuperview()
            .toRightOf(iconHistory, constant: 10)
            .alignEdgesWithSuperview([.right, .top, .bottom], constants: [10, 10, 10])
    }
}

// MARK: - Binding
private extension SearchHistoryTableViewCell {
    func bindView(with viewModel: SearchHistoryTableViewCellViewModelType) {
        viewModel.outputs.title.bind(to: title.rx.text).disposed(by: disposeBag)
        viewModel.outputs.isHideHeading.bind(to: heading.rx.isHidden).disposed(by: disposeBag)
    }
}
