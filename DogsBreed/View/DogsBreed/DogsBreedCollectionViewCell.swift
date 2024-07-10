//
//  DogsBreedCollectionViewCell.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 09/07/24.
//

import UIKit

class DogsBreedCollectionViewCell: UICollectionViewCell {

    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var breedNameLabel: UILabel!
    
    //MARK: -> Properties
      
    //MARK: -> LifeCycle
      override func awakeFromNib() {
          super.awakeFromNib()
          configureUI()
      }

  //MARK: -> Helpers
    func configureUI() {
        containerView.dropShadow()
    }

  //MARK: -> Button Actions

  }
