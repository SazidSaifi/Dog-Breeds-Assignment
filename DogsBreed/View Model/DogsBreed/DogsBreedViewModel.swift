//  DogsBreedViewModel.swift
//  DogsBreed
//  Created by Sazid Saifi on 09/07/24.

import Foundation


struct DogsBreedViewModel {
    
    //MARK: - PROPERTIES
    
    //MARK: - API INTEGRATION
    func getBreedList(with completionHandler: @escaping ((BreedListModel?, String?) -> ())) {
        guard let url = URL(string: Endpoints.baseUrl + Endpoints.breeedList) else { fatalError("URL is incorrect.") }
        print(url)
        var resource = Resource<BreedListModel?>(url: url)
        resource.httpMethods = .get
        DispatchQueue.main.async { Spinner.start() }
        WebService().load(resource: resource) { result, jsonData in
            DispatchQueue.main.async { Spinner.stop() }
            switch result {
            case .success(let data):
                if let data = data {
                    completionHandler(data, nil)
                }
            case .failure(let error):
                let error = error.get()
                completionHandler(nil, error)
            }
        }
    }
}
