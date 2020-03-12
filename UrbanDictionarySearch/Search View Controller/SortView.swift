//
//  SortView.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/9/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import UIKit

protocol SortViewDelegate {
    func mostToLeastTapped()
    func leastToMostTapped()
}

class SortView: UITableViewHeaderFooterView {
    private struct Constants {
        static let horizontalMargin: CGFloat = 20.0
        static let verticalMargin: CGFloat = 10.0
    }
    
    static let reuseID = "SortView"
    var delegate: SortViewDelegate?
    
    let mostToLeastSortButton: UIButton
    let leastToMostSortButton: UIButton
    
    override init(reuseIdentifier: String?) {
        self.mostToLeastSortButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("High First", for: .normal)
            button.backgroundColor = .green
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            
            return button
        }()
        
        self.leastToMostSortButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Low First", for: .normal)
            button.backgroundColor = .red
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            
            return button
        }()
        
        super.init(reuseIdentifier: SortView.reuseID)
        mostToLeastSortButton.addTarget(self, action: #selector(mostToLeastButtonTapped), for: .touchUpInside)
        leastToMostSortButton.addTarget(self, action: #selector(leastToMostButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(mostToLeastSortButton)
        contentView.addSubview(leastToMostSortButton)
        
        NSLayoutConstraint.activate([
            mostToLeastSortButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            mostToLeastSortButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            mostToLeastSortButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Constants.horizontalMargin),
            mostToLeastSortButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin),
            leastToMostSortButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            leastToMostSortButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            leastToMostSortButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin),
            leastToMostSortButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: Constants.horizontalMargin)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func mostToLeastButtonTapped() {
        delegate?.mostToLeastTapped()
    }
    
    @objc
    private func leastToMostButtonTapped() {
        delegate?.leastToMostTapped()
    }
}
