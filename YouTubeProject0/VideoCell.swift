//
//  VideoCell.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 19..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews()
    {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class VideoCell: BaseCell {

    var video : Video?
    {
        didSet
        {
            setupThunmbnailImage()
            setupProfileImage()
            
            titleLabel.text = video?.title
            thumbNailImageView.image = UIImage(named: (video?.thumbnail_image_name)!)
            
            if let profileImageName = video?.channel?.profile_image_name
            {
                userProfileImageView.image = UIImage(named: profileImageName)
                
               
            }
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.number_of_views
            {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberOfViews)!) - 2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            //measure title text
            
            if let title = video?.title
            {
                
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
 
                let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

                let estimatedRect = NSString(string: title).boundingRect(with: size, options: option, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil)
                
                /*
                 원래 코드는 이건데 이거 작동 안한다
                 if estimatedRect.size.height > 20
                 {
                 titleLabelHeightConstraint?.constant = 44
                 
                 print(estimatedRect)
                 
                 }else
                 {
                 titleLabelHeightConstraint?.constant = 20
                 
                 print(estimatedRect)
                 
                 }
                 */
 
 
                if estimatedRect.width > 250
                {
                    titleLabelHeightConstraint?.constant = 44
                    
                    


                }else
                {
                    titleLabelHeightConstraint?.constant = 20
                    
                    

                }
 
            }
            
        }
    }
    
    func setupProfileImage()
    {
        if let profileImageUrl = video?.channel?.profile_image_name
        {
            userProfileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
    }
    
    func setupThunmbnailImage()
    {
        if let thumnailImageUrl = video?.thumbnail_image_name
        {
            thumbNailImageView.loadImageUsingUrlString(urlString: thumnailImageUrl)
        }
    }
    
    
    let thumbNailImageView:CustomImageView =
    {
        let imageView = CustomImageView()
        //        imageView.backgroundColor = UIColor.blue
        imageView.image = UIImage(named: "TaylorSwift1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let userProfileImageView: CustomImageView =
    {
        let imageView = CustomImageView()
        //        imageView.backgroundColor = UIColor.green
        imageView.image = UIImage(named: "TaylorSwift2")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    let separatorView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        return view
    }()
    
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        //        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView =
    {
        let textView = UITextView()
        //        textView.backgroundColor = UIColor.red
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO - 1,604,684,607 views - 2 years ago"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleLabelHeightConstraint:NSLayoutConstraint?
    
    override func setupViews()
    {
        addSubview(thumbNailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        // 썸네일 이미지 뷰 수평 컨스트레인트
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbNailImageView)
        
        // 유저프로필 이미지 뷰 수평 컨스트레인트
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        // 썸네일, 유저프로필, 세퍼레이터뷰(여기서 height:1로 결정됨) 수직 컨스트레인트
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-38-[v2(1)]|", views: thumbNailImageView,userProfileImageView ,separatorView)
        
        // 세퍼레이터뷰(상위 view와 같은 width로 결정됨) 수평 컨스트레인트
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        
        // titleLabel constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: thumbNailImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: userProfileImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: thumbNailImageView, attribute: NSLayoutAttribute.right,multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 44))
        
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 20)
        
        addConstraint(titleLabelHeightConstraint!)
        
        // subtitleTextView contraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: userProfileImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: thumbNailImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 30))
        
        
    }
    
}
