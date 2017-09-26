//
//  FeedCell.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 21..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

protocol FeedCellDelegate {
    func swipeUpNavBar()
    func swipeDownNavBar()
}

class FeedCell: BaseCell, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var delegate:FeedCellDelegate?
    
    lazy var collectionView:UICollectionView =
    {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
        return cv
    }()
    
    var videos: [Video]?
    
    let cellId = "cellId"
    
    func fetchVideos()
    {
        ApiService.sharedInstance.fetchHomeFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
        
    }

    override func setupViews() {
        
        super.setupViews()
        fetchVideos()
        backgroundColor = UIColor.brown
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // width 여백 뺀후 16 : 9 비율로 만든 것
        let height = (frame.width - 16 - 16) * 9 / 16
        
        return CGSize(width:frame.width, height:height + 16 + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }

}
