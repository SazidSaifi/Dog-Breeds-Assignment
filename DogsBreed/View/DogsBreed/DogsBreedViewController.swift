//  DogsBreedViewController.swift
//  DogsBreed
//  Created by Sazid Saifi on 09/07/24.

import UIKit

class DogsBreedViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favouritesBUtton: UIButton!
    @IBOutlet weak var navigationBar: NavigationBar!
    
    //MARK: -> Properties
    var viewModel = DogsBreedViewModel()
    var dogBreedsResponse: BreedListModel?
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getEndorsementListData()
        registerCell()
        configureNavigation()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        favouritesBUtton.backgroundColor = UIColor.themeColor
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerCell(){
        
        collectionView.register(UINib(nibName: "DogsBreedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogsBreedCollectionViewCell")
    }
    
    // MARK: - Navigation
    private func configureNavigation() {
        let navigationBar = Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)?.first as? NavigationBar
        navigationBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        navigationBar?.frame = self.navigationBar.bounds
        navigationBar?.configureUI(with:"", title: "Breed List", isShowBack: true)
        self.navigationBar.addSubview(navigationBar!)
    }
    
    //MARK: -> Button Actions
    @IBAction func favouritesBUtton(_ sender: UIButton) {
        let stb = UIStoryboard(name: "FavouritesBreedsStoryboard", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "FavouritesBreedsViewController") as! FavouritesBreedsViewController
        if let breedsList = dogBreedsResponse?.message {
            vc.arrayOfBreeds =  Array(breedsList.keys)
        }
       
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: - View Model Interation
extension DogsBreedViewController {
    private func getEndorsementListData() {
        viewModel.getBreedList { data, error in
            if let data = data {
                if  data.status == "success"{
                    self.dogBreedsResponse = data
                    print("Breeds Lis:: ",self.dogBreedsResponse?.message.count ?? 0)
                    self.collectionView.reloadData()
                }
            }
            if error != nil {
                DispatchQueue.main.async {
                    if let error = error {
                        
                    }
                }
            }
        }
    }
}

extension DogsBreedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogBreedsResponse?.message.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogsBreedCollectionViewCell", for: indexPath) as! DogsBreedCollectionViewCell
         if let dogBreedsResponse = dogBreedsResponse {
            let breed = Array(dogBreedsResponse.message.keys)[indexPath.row]
            let subBreeds = dogBreedsResponse.message[breed] ?? []
             cell.breedNameLabel.text = breed.capitalizedFirstLetter()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dogBreedsResponse = dogBreedsResponse {
            let stb = UIStoryboard(name: "DogBreedsDetailsStoryboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "DogBreedsDetailsViewController") as! DogBreedsDetailsViewController
            let breed = Array(dogBreedsResponse.message.keys)[indexPath.row]
            vc.breedName = breed
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = collectionView.frame.size.width - padding * 4
        return CGSize(width: collectionViewSize / 3, height: collectionViewSize / 3)
    }
}
