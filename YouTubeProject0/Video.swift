//
//  Video.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 19..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        
        //안전하게 받아오는 과정
        let upperCaseFirstCharacter = String(key.characters.first!).uppercased()
//        let range = key.startIndex..<key.index(key.startIndex, offsetBy: 1)
//        let selectorString = key.replacingCharacters(in: range, with:
//            upperCaseFirstCharacter)
        
        let range2 = NSMakeRange(0, 1)
        let selectorString2 = NSString(string: key).replacingCharacters(in: range2, with: upperCaseFirstCharacter)
        
        let selector = NSSelectorFromString("set\(selectorString2):")
        let responds = self.responds(to: selector)
        
        if !responds{
            return
        }
        super.setValue(value, forKey: key)
    }
}

class Video: SafeJsonObject {
    var thumbnail_image_name: String?
    var title:String?
    var number_of_views:NSNumber?
    var uploadDate:NSDate?
    var duration:NSNumber?
    
    var channel: Channel?
    
    
    
    override func setValue(_ value: Any?, forKey key: String) {

        if key == "channel"
        {
            //custom channel setup
            
            self.channel = Channel()
            
            self.channel?.setValuesForKeys(value as! [String:AnyObject])

            
        }else
        {
            
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary:[String:AnyObject])
    {
        super.init()
        //밑에 펑션이 위에 setValue호출
        setValuesForKeys(dictionary)
    }
    
//    var num_likes:NSNumber?
}

class Channel: SafeJsonObject {
    var name:String?
    var profile_image_name:String?
}

// https://s3-us-west-2.amazonaws.com/youtubeassets/home.json
