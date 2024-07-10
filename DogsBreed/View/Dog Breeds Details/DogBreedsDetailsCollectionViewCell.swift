//  DogBreedsDetailsCollectionViewCell.swift
//  DogsBreed
//  Created by Sazid Saifi on 10/07/24.

import UIKit

class DogBreedsDetailsCollectionViewCell: UICollectionViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    //MARK: -> Properties
    var didClickLike: (() ->Void)?
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        containerView.dropShadow()
        likeImageView.clipsToBounds = true
        containerView.clipsToBounds = true
    }
    
    func configureData(breedImage: String) {
        breedImageView.sd_setImage(with: URL(string: breedImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        if LocalStorege.checkavedData(breedData: breedImage) {
            likeImageView.image = UIImage(named: "like")
        } else {
            likeImageView.image = UIImage(named: "unlike")
        }
    }
    
    //MARK: -> Button Actions
    @IBAction func likeButtton(_ sender: UIButton) {
        didClickLike?()
    }
}
