//
//  SettingCell.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 20..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool
    {
        didSet
        {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            // 밑에 tintColor 바꾸려면 setting didSet 에 iconImageView.image = UIImage(named: imageName)..withRenderingMode(.alwaysTemplate) 이거 해야 된다
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
            print(isHighlighted)
        }
    }
    
    var setting:Setting?
    {
        didSet
        {
            nameLabel.text = setting?.name.rawValue
            
            if let imageName = setting?.imageName
            {
                
                iconImageView.image = UIImage(named:imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel =
    {
       let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 14)
//        label.textAlignment = .right
        
        return label
    }()
    
    let iconImageView:UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"setting")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView,nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
