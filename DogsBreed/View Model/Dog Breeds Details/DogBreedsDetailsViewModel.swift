//  DogBreedsDetailsViewModel.swift
//  DogsBreed
//  Created by Sazid Saifi on 10/07/24.

import Foundation
import MBProgressHUD

class DogBreedsDetailsViewModel {
    
    //MARK: - API INTEGRATION
    func getBreedDetails(breedName: String, with completionHandler: @escaping ((DogBreedsDetailModel?, String?) -> ())) {
        guard let url = URL(string: Endpoints.baseUrl + Endpoints.breeedDetails + breedName + "/images") else { fatalError("URL is incorrect.") }
        print(url)
        var resource = Resource<DogBreedsDetailModel?>(url: url)
        resource.httpMethods = .get
        DispatchQueue.main.async {
            Spinner.start()
        }
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



