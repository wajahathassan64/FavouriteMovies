//
//  NoSearchResultCell.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 17/04/2021.
//

import Foundation
import RxSwift

class NoSearchResultCell: RxUITableViewCell {
    
    // MARK: Views
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No results"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: Properties
    
    private var viewModel: NoSearchResultCellViewModelType!
    
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
        guard let viewModel = viewModel as? NoSearchResultCellViewModelType else { return }
        self.viewModel = viewModel
        bindView(with: viewModel)
    }
}

// MARK: View setup

private extension NoSearchResultCell {
    func setupViews() {
        backgroundColor = .black
        contentView.addSubview(title)
    }
    
    func setupConstraints() {
        title
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [25, 65, 25, 15])
    }
}

// MARK: - Binding

private extension NoSearchResultCell {
    func bindView(with viewModel: NoSearchResultCellViewModelType) {
        viewModel.outputs.title.bind(to: title.rx.text).disposed(by: disposeBag)
    }
}
