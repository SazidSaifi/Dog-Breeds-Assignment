//
//  NavigationBar.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 10/07/24.
//

import UIKit

class NavigationBar: UIView {

    //MARK: -> outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImageContainerView: UIView!
    
    //MARK: -> properties
    var didClickBack:(()->Void)?
    
    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    func configureUI(with backImageIcon: String?, title: String, isShowBack: Bool) {
        if isShowBack {
            backImageContainerView.isHidden = false
        } else {
            backImageContainerView.isHidden = true
        }
        
        if let backImageIcon = backImageIcon {
            backIconImageView.image = UIImage(named: backImageIcon)
        }
        
        var CapitalizeText = title
        CapitalizeText.capitalizeFirstLetter()
        titleLabel.text = CapitalizeText
    }

    //MARK: - Button Actions
    @IBAction func backButton(_ sender: UIButton) {
        didClickBack?()
    }
}
