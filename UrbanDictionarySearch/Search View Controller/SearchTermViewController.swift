//
//  SearchTermViewController.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/6/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import UIKit
import Combine

class SearchTermViewController: UIViewController {
    let dictionaryPublisher = UrbanDictionaryClient()
    var dataSource: DefinitionListDataSource?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(DefinitionCell.self, forCellReuseIdentifier: DefinitionCell.reuseID)
        tableView.register(SortView.self, forHeaderFooterViewReuseIdentifier: SortView.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 50
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Look Up"
        searchController.searchBar.delegate = self
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dictionaryPublisher.subscribe(self)
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func handleDataSource(dataSource: DefinitionListDataSource) {
        self.dataSource = dataSource
        title = dataSource.searchTerm
        
        if dataSource.isFetching {
            tableView.isHidden = true
            activityIndicator.startAnimating()
        } else if dataSource.definitions?.count ?? 0 > 0 {
            tableView.isHidden = false
            activityIndicator.stopAnimating()
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            activityIndicator.stopAnimating()
            //show error message.
            let alertController = UIAlertController(
                title: "Oops, something went wrong.",
                message: dataSource.statusMessage,
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okie Dokie", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension SearchTermViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Not updating as the user types...
    }
}

extension SearchTermViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchBar.endEditing(true)
        dictionaryPublisher.fetchDefinitions(for: searchTerm, sortOrder: .mostToLeast)
        searchController.isActive = false
    }
}

extension SearchTermViewController: Subscriber {
    typealias Input = DefinitionListDataSource
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: DefinitionListDataSource) -> Subscribers.Demand {
        handleDataSource(dataSource: input)
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
    
    }
}

extension SearchTermViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.definitions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let definition = dataSource?.definitions?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: DefinitionCell.reuseID) as? DefinitionCell
        else { fatalError() }
        
        cell.definition = definition
        return cell
    }
}

extension SearchTermViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sortHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SortView.reuseID) as? SortView
        else {
            fatalError()
        }
        
        sortHeader.delegate = self
        return sortHeader
    }
}

extension SearchTermViewController: SortViewDelegate {
    func mostToLeastTapped() {
        guard let searchTerm = dataSource?.searchTerm else { return }
        dictionaryPublisher.fetchDefinitions(for: searchTerm, sortOrder: .mostToLeast)
    }
    
    func leastToMostTapped() {
        guard let searchTerm = dataSource?.searchTerm else { return }
        dictionaryPublisher.fetchDefinitions(for: searchTerm, sortOrder: .leastToMost)
    }
}
