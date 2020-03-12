//
//  DefinitionCell.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/9/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import UIKit

class DefinitionCell: UITableViewCell {
    static let reuseID = "DefinitionCell"
    
    private struct Constants {
        static let standardMargin: CGFloat = 20.0
        static let spacing: CGFloat = 8.0
    }
    
    let definitionTextLabel: UILabel
    let countStackView: UIStackView
    let upvoteLabel: UILabel
    let downvoteLabel: UILabel
    
    var definition: Definition? {
        didSet {
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        definitionTextLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = UIFont.preferredFont(forTextStyle: .body)
            
            return label
        }()
        
        countStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            return stackView
            
        }()
        
        upvoteLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .green
            label.numberOfLines = 1
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            
            return label
        }()
        
        downvoteLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .red
            label.numberOfLines = 1
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.textAlignment = .right
            
            return label
        }()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(definitionTextLabel)
        contentView.addSubview(countStackView)
        countStackView.addArrangedSubview(upvoteLabel)
        countStackView.addArrangedSubview(downvoteLabel)
        
        NSLayoutConstraint.activate([
            definitionTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.standardMargin),
            definitionTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.standardMargin),
            definitionTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.standardMargin),
            countStackView.topAnchor.constraint(equalTo: definitionTextLabel.bottomAnchor, constant: Constants.spacing),
            countStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.standardMargin),
            countStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.standardMargin),
            countStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.standardMargin)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        definitionTextLabel.text = definition?.text ?? ""
        upvoteLabel.text = "\(definition?.upVoteCount ?? 0)"
        downvoteLabel.text = "\(definition?.downVoteCount ?? 0)"
    }
}
