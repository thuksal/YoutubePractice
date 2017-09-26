//
//  VideoLauncher.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 21..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView
{
    let activityIndicatorView:UIActivityIndicatorView =
    {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
   lazy var pausePlayButton : UIButton =
    {
        let button = UIButton(type: UIButtonType.system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: UIControlState.normal)
        button.tintColor = UIColor.white
        //밑에 추가 해야 컨테이너 뷰에 들어갈 수 있다. 이거 자주 한거 ㅇㅇ contraint 줄 때 반드시 해야함
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
//        button.isHidden = true

        return button
    }()
    
    var isPlaying:Bool = false
    
    func handlePause()
    {
        if isPlaying
        {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
        }else
        {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState.normal)
        }
        
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel:UILabel =
    {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel:UILabel =
    {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)

        return label
    }()
    
    let videoSlider:UISlider =
    {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
//        slider.thumbTintColor = UIColor.red

        
        //1. Assets 에 넣을 때 *1 *2 *3 으로 크기 조절할 수 있다 숫자 커질 수록 크기 작아짐
        //2. thumb 크기는 image 조절로 밖에 못한다. thmbImage를 작게 만들고 싶으면 이미지 캡쳐할 때 크기는 작게, 대신 이미지 자체는 캡쳐 사이즈에 꽉 차게 캡쳐해야 여백을 없앨 수 있다.
        slider.setThumbImage(UIImage(named:"dot6")?.withRenderingMode(.alwaysTemplate), for: .normal)

        slider.tintColor = UIColor.red
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    func handleContarinerTap(data:UIGestureRecognizer)
    {
        controlsContainerView.alpha = 1
    }
    
    func handleSliderTap(data:UIGestureRecognizer)
    {
        
        let pointTapped: CGPoint = data.location(in: videoSlider)
       
//        let positionOfSlider: CGPoint = videoSlider.frame.origin
        
        let widthOfSlider: CGFloat = videoSlider.frame.size.width
        let newValue = pointTapped.x / widthOfSlider
        print(newValue)
        
        if let duration = player?.currentItem?.duration
        {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(newValue) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
//            player?.seek(to: seekTime, completionHandler: { (completion) in
//                
//            })
            
            player?.seek(to: seekTime)

        }
    }
    
    func handleSliderChange()
    {
        
        
        if let duration = player?.currentItem?.duration
        {
            
            //let totalSeconds = CMTimeGetSeconds(player.currentItem.duration)은 말 그대로 totalSeconds를 추적
            let totalSeconds = CMTimeGetSeconds(duration)
            
            //videoSlider.value는 0부터 1까지
            let value = Float64(videoSlider.value) * totalSeconds
            
            //value / timescale = second 니까 timescale 이 1이면 바로 totalSeconds가 된다. 그러므로 totalSeconds로 찾아감
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            
        })
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleSliderTap(data:)))
        videoSlider.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(handleContarinerTap(data:)))
        controlsContainerView.addGestureRecognizer(gesture2)
        
        
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 52).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 58).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -4).isActive = true
//        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: -8).isActive = true
        videoSlider.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        backgroundColor = UIColor.black

    }
    var player:AVPlayer?
    
    private func setupPlayerView()
    {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        
        if let url = URL(string: urlString)
        {
            player = AVPlayer(url: url as URL)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            
            //this is when the player is ready and rendering frames 관찰
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            
            //track player progress
            
            //0.5초마다 추적 value / timescale = second
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                
                //String(format:) 에서 %는 character 02는 개수 d는 Int 를 가리키는듯?
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                
                //lets move the slider thumb
                if let duration = self.player?.currentItem?.duration
                {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                    
                    let secondsString2 = String(format: "%02d", Int(durationSeconds - seconds) % 60)
                    let minutesString2 = String(format: "%02d", Int(durationSeconds - seconds) / 60)
                    self.videoLengthLabel.text = "\(minutesString2):\(secondsString2)"
                    
                }
                
            })
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //this is when the player is ready and rendering frames 관찰
        if keyPath == "currentItem.loadedTimeRanges"
        {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            
            
            
            UIView.animate(withDuration: 0.5, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                self.controlsContainerView.removeFromSuperview()
//                self.controlsContainerView.isHidden = true
                self.controlsContainerView.alpha = 0
            }, completion: nil)

//            pausePlayButton.isHidden = false
            
            
            isPlaying = true
            
//            if let duration = player?.currentItem?.duration
//            {
//                let seconds = CMTimeGetSeconds(duration)
//                
//                let secondsText = Int(seconds) % 60
//                let minutesText = String(format: "%02d" ,Int(seconds) / 60)
//                
//                videoLengthLabel.text = "\(minutesText):\(secondsText)"
//            }
        }
    }
    
    private func setupGradientLayer()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.7,1.2]
        
        
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    func tapVideoPlayer(_:UIGestureRecognizer)
    {
        if isPlaying && controlsContainerView.alpha == 0
        {
            controlsContainerView.alpha = 1
//            UIView.animate(withDuration: 1, delay: 3, options: UIViewAnimationOptions.curveEaseOut, animations: { 
//                self.controlsContainerView.isHidden = true
//            }, completion: nil)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    func showVideoPlayer()
    {
        print("showing video player animation...")
        
        if let keyWindow = UIApplication.shared.keyWindow
        {
            
            //베이스 뷰 만듦
            let view = UIView()
            view.backgroundColor = UIColor.white
            
            //베이스 뷰 에니메이팅 전 프레임
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            //베이스 뷰 위에 비디오 플레이어 뷰 만듦. 여기서 이미 최종적으로 다다를 프레임 짬. 차후에 에니메이팅 할 때는 베이스 뷰 프레임만 조절하면 알아서 따라온다.
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame:videoPlayerFrame)
            
            
            //비디오 플레이어뷰 탭 터치 컨트롤
            let tapGesure = UITapGestureRecognizer(target: videoPlayerView, action: #selector(videoPlayerView.tapVideoPlayer(_:)))
            videoPlayerView.addGestureRecognizer(tapGesure)
            
            //베이스 뷰에 비디어플레이어 뷰 add
            view.addSubview(videoPlayerView)
            
            //키 윈도우에 베이스 뷰 add
            keyWindow.addSubview(view)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //에니메이팅 후 최종적으로 다다를 프레임. 비디오 플레이어 뷰는 이미 최종 프레임 알려주고 베이스 뷰 위에 올려놨으므로 안 알려줘도 됨.
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                UIApplication.shared.isStatusBarHidden = true

                
//                UIApplication
//                UIApplication.shared.isStatusBarHidden = true
            })
        }
        
        
    }
    
}
