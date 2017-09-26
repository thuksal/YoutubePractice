//
//  TrendingCell.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 21..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos()
    {
        
        ApiService.sharedInstance.fetchTrendingFeed
            { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
