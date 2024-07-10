//  FavouritesBreedsViewController.swift
//  DogsBreed
//  Created by Sazid Saifi on 10/07/24.

import UIKit
import DropDown

class FavouritesBreedsViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filiterLabel: UILabel!
    
    @IBOutlet weak var dropDownContainerView: UIView!
    
    //MARK: -> Properties
    var viewModel = FavouritesBreedsViewModel()
    var arrayOfFavourites = [String]()
    var arrayOfBreeds = [String]()
    var background: BackgroundView?
    let dropdown = DropDown()
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        registerCell()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        dropDownContainerView.layer.borderWidth = 1.0
        dropDownContainerView.layer.borderColor = UIColor.lightGray.cgColor
        dropDownContainerView.layer.cornerRadius = 4.0
        dropDownContainerView.clipsToBounds = true
        dropDownContainerView.backgroundColor = UIColor.themeColor
        collectionView.delegate = self
        collectionView.dataSource = self
        if let favouritesList = LocalStorege.retrieveData() {
            arrayOfFavourites = favouritesList
        }
        configureBackgroundList(with: "noDataFound", count: arrayOfFavourites.count)
    }
    
    // MARK: - Navigation
    private func configureNavigation() {
        let navigationBar = Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)?.first as? NavigationBar
        navigationBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        navigationBar?.frame = self.navigationBar.bounds
        navigationBar?.configureUI(with:"back", title: "Favourites Breeds", isShowBack: true)
        
        navigationBar?.didClickBack = {
            self.navigationController?.popViewController(animated: false)
        }
        
        self.navigationBar.addSubview(navigationBar!)
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "DogBreedsDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogBreedsDetailsCollectionViewCell")
    }
    
    private func configureBackgroundList(with image: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image)
                }
                collectionView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                collectionView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: -> Button Actions
    @IBAction func filterButton(_ sender: UIButton) {
        configureBreedDropdown(anchorView: filterButton, and: self.arrayOfBreeds)
        self.dropdown.show()
        dropdown.selectionAction = { (index: Int, item: String) in
            self.filiterLabel.text = item
            self.getBreedDetails(breedName: item)
        }
    }
}

//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FavouritesBreedsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfFavourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogBreedsDetailsCollectionViewCell", for: indexPath) as! DogBreedsDetailsCollectionViewCell
        let image = arrayOfFavourites[indexPath.row]
        cell.configureData(breedImage: image)
        cell.likeImageView.image = UIImage(named: "like")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = collectionView.frame.size.width - padding * 4
        return CGSize(width: collectionViewSize / 3, height: collectionViewSize / 3)
    }
}

//MARK: -> configureBreedDropdown
extension FavouritesBreedsViewController {
    private func configureBreedDropdown(anchorView: UIView, and dataValues: [String]?) {
        dropdown.anchorView = anchorView
        dropdown.bottomOffset = CGPoint(x: 0, y: (anchorView.bounds.height + 4))
        dropdown.width = 200
        dropdown.textColor = UIColor.black
        dropdown.layer.masksToBounds = true
        dropdown.cornerRadius = 5
        dropdown.backgroundColor = UIColor.white
        dropdown.selectionBackgroundColor = UIColor.lightGray
        var datasource = [String]()
        if let values = dataValues {
            for value in values {
                datasource.append(value ?? "NA")
            }
        }
        dropdown.dataSource = datasource
    }

}

//MARK: - View Model Interation
extension FavouritesBreedsViewController {
    private func getBreedDetails(breedName: String) {
        viewModel.getBreedDetails(breedName: breedName) { data, error in
            if let data = data {
                if  data.status == "success"{
                    if let favouritesList = LocalStorege.retrieveData() {
                        let commonElements = data.message.filter { favouritesList.contains($0) }
                        self.arrayOfFavourites = commonElements
                    }
                    self.collectionView.reloadData()
                    self.configureBackgroundList(with: "noDataFound", count:  self.arrayOfFavourites.count ?? 0)
                }
            }
            if error != nil {
                self.configureBackgroundList(with: "noDataFound", count: data?.message.count ?? 0)
                DispatchQueue.main.async {
                    if let error = error {
                    }
                }
            }
        }
    }
}
