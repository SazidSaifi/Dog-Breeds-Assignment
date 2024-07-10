//  BackgroundView.swift
//  DogsBreed
//  Created by Sazid Saifi on 10/07/24.

import UIKit

class BackgroundView: UIView {

    //MARK: -> OutLets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Button Action
   
    //MARK: -> Helpers
    func configureUI() {
  
    }
    
    func configureUI(with backgroundImageName: String?) {
        if let image = backgroundImageName {
            backgroundImageView.image = UIImage(named: image)
        }
    }
    
}
