//
//  Extensions.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 19..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit


extension UIColor
{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView
{
    func addConstraintsWithFormat(format: String, views:UIView...)
    {
        
        var viewDictionary = [String:UIView]()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
//위, 아래로 스크롤 할 떄마다 이미지 다시 불러와야 되는 거 방지 하려고 캐쉬 씀
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView
{
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString:String)
    {
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = imageFromCache
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil
            {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data:data!)
                
                if self.imageUrlString == urlString
                {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)

            }
        }).resume()
    }
}
