//
//  ApiService.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 21..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func fetchHomeFeed(completion: @escaping ([Video])-> ())
    {
        fetchFeedForUrlString(urlString: "\(baseUrl)home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video])-> ())
    {
        
        fetchFeedForUrlString(urlString: "\(baseUrl)trending.json", completion: completion)
    }
    
    func fetchSubscriptionsFeed(completion: @escaping ([Video])-> ())
    {
        
        fetchFeedForUrlString(urlString: "\(baseUrl)subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString:String, completion: @escaping ([Video])-> ())
    {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String:AnyObject]]
                {

//                    var videos = [Video]()
//                    
//                    for dictionary in jsonDictionaries
//                    {
//                        let video = Video(dictionary: dictionary)
//                        video.setValuesForKeys(dictionary)
//                        
//                        //여기서 append된 videos를 밖으로 꺼내서 homeController에 날려줘야 되므로 @escaping completion을 쓴다
//                        videos.append(video)
//                    }

                    DispatchQueue.main.async {
                        //이 펑션 안에서 생성된 videos가 밖으로 나가므로 @escaping 이 쓰임
                        completion(jsonDictionaries.map({ return Video(dictionary: $0)
                        })
                        )
                    }
                }
            }catch let jsonError
            {
                print(jsonError)
            }
            }.resume()
    }
    
}

//let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//print(json)
//
//// 이 밑에 한 줄이 왜 필요하냐면 옵셔널로 선언해서 append가 안되거든 옵셔널 풀어준거 !!
//var videos = [Video]()
//
//
//
//for dictionary in json as! [[String:AnyObject]]
//{
//    let video = Video()
//    video.title = dictionary["title"] as? String
//    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//    
//    let channelDictionary = dictionary["channel"] as! [String:AnyObject]
//    let channel = Channel()
//    channel.name = channelDictionary["name"] as? String
//    channel.profileImageName = channelDictionary["profile_image_name"] as? String
//    video.channel = channel
//    
//    //여기서 append된 videos를 밖으로 꺼내서 homeController에 날려줘야 되므로 @escaping completion을 쓴다
//    videos.append(video)
//}
//
//DispatchQueue.main.async {
//    
//    //이 펑션 안에서 생성된 videos가 밖으로 나가므로 @escaping 이 쓰임
//    completion(videos)
//}
