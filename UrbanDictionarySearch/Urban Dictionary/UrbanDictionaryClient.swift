//
//  UrbanDictionaryClient.swift
//  UrbanDictionarySearch
//
//  Created by Brian Rozboril on 3/8/20.
//  Copyright © 2020 Spiffy Ghost Software, LLC. All rights reserved.
//

import Combine
import UIKit

enum UrbanDictionaryError: LocalizedError {
    case error
}

class UrbanDictionaryClient {
    
    private let definitionsURL = "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term="
    private let headers = [
        "x-rapidapi-host": "mashape-community-urban-dictionary.p.rapidapi.com",
        "x-rapidapi-key": "7388e2ec19msh203183093398025p122a6cjsn7d2ae7b75ce7"
    ]
    
    let workerQueue = DispatchQueue.global(qos: .default)
    var cancellable: AnyCancellable?
    let subject = PassthroughSubject<DefinitionListDataSource, Never>()
    
    private func process(searchTerm: String, sort: SortOrder) {
        guard let formattedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            let dataSource = UrbanDictionaryDefinitionListDataSource(searchTerm: searchTerm, statusMessage: "Invalid input")
            subject.send(dataSource)
            return
        }
        
        guard let url = URL(string: "\(definitionsURL)\(formattedSearchTerm)") else {
            let dataSource = UrbanDictionaryDefinitionListDataSource(searchTerm: searchTerm, statusMessage: "Server not found.")
            subject.send(dataSource)
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw UrbanDictionaryError.error
            }
            return output.data
        }
        .decode(type: UrbanDictionaryResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                let dataSource = UrbanDictionaryDefinitionListDataSource(
                    searchTerm: searchTerm,
                    statusMessage: error.localizedDescription
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.subject.send(dataSource)
                }
            }
        }) { [weak self] response in
            let ubDataSource = UrbanDictionaryDefinitionListDataSource(
                isFetching: false,
                searchTerm: searchTerm,
                definitions: sort == .leastToMost ? response.list.leastToMost : response.list
            )
            DispatchQueue.main.async {
                self?.subject.send(ubDataSource)
            }
        }
    }
}

extension UrbanDictionaryClient: DictionaryPublisher {    
    func fetchDefinitions(for searchTerm: String, sortOrder: SortOrder) {
        cancellable?.cancel()
        subject.send(UrbanDictionaryDefinitionListDataSource(
            isFetching: true,
            searchTerm: searchTerm,
            definitions: nil)
        )
        
        workerQueue.async { [weak self] in
            self?.process(searchTerm: searchTerm, sort: sortOrder)
        }
    }
    
    typealias Output = DefinitionListDataSource
    typealias Failure = Never

    func receive<S>(subscriber: S)
        where S : Subscriber, UrbanDictionaryClient.Failure == S.Failure,
                  UrbanDictionaryClient.Output == S.Input
    {
        subject.subscribe(subscriber)
    }
}
