//  DogBreedsDetailsViewController.swift
//  DogsBreed
//  Created by Sazid Saifi on 10/07/24.

import UIKit
import SDWebImage

class DogBreedsDetailsViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet weak var backgroundView: BackgroundView!

    
    //MARK: -> Properties
    var viewModel = DogBreedsDetailsViewModel()
    var breedDetails: DogBreedsDetailModel?
    var breedName: String?
    var background: BackgroundView?
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
        configureNavigation()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let breedName = breedName {
            self.getBreedDetails(breedName: breedName)
        }
        let data = LocalStorege.retrieveData()
        print("retrieveData Count::: ", data)
    }
    
    // MARK: - Navigation
    private func configureNavigation() {
        let navigationBar = Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)?.first as? NavigationBar
        navigationBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        navigationBar?.frame = self.navigationBar.bounds
        
        if let breedName = breedName {
            navigationBar?.configureUI(with:"back", title: breedName, isShowBack: true)
        }
        
        navigationBar?.didClickBack = {
            self.navigationController?.popViewController(animated: false)
        }
        
        self.navigationBar.addSubview(navigationBar!)
    }
    
    func registerCell(){
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
}

//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DogBreedsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedDetails?.message.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogBreedsDetailsCollectionViewCell", for: indexPath) as! DogBreedsDetailsCollectionViewCell
        if let image = breedDetails?.message[indexPath.row] {
            cell.configureData(breedImage:image)
        }
        
        cell.didClickLike = {
            if let image = self.breedDetails?.message[indexPath.row] {
                LocalStorege.addData(image)
                if LocalStorege.checkavedData(breedData: image) {
                    cell.likeImageView.image = UIImage(named: "like")
                } else {
                    cell.likeImageView.image = UIImage(named: "unlike")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = collectionView.frame.size.width - padding * 4
        return CGSize(width: collectionViewSize / 3, height: collectionViewSize / 3)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if  let breedData = breedDetails?.message[indexPath.row] {
//                LocalStorege.addData(breedData)
//        }
//    }
}

//MARK: - View Model Interation
extension DogBreedsDetailsViewController {
    private func getBreedDetails(breedName: String) {
        viewModel.getBreedDetails(breedName: breedName) { data, error in
            if let data = data {
                if  data.status == "success"{
                    self.breedDetails = data
                    print("Breeds Lis:: ",self.breedDetails?.message.count ?? 0)
                    self.collectionView.reloadData()
                    self.configureBackgroundList(with: "noDataFound", count: self.breedDetails?.message.count ?? 0)
                }
            }
            if error != nil {
                self.configureBackgroundList(with: "noDataFound", count: self.breedDetails?.message.count ?? 0)
                DispatchQueue.main.async {
                    if let error = error {
                        
                    }
                }
            }
        }
       
    }
}
