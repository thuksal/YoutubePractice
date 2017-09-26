//
//  SettingLauncher.swift
//  YouTubeProject0
//
//  Created by 김태형 on 2017. 9. 20..
//  Copyright © 2017년 김태형. All rights reserved.
//

import UIKit

class Setting: NSObject
{
    let name:SettingName
    let imageName:String
    
    init(name:SettingName,imageName:String)
    {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName:String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case TermsPrivacy = "Terms & Privacy policy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
}

class SettingLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let collectionView:UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight:CGFloat = 50
    
    let settings:[Setting] =
    {
        let settingSetting = Setting(name: .Settings, imageName: "setting")
        
        let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
        
        return [settingSetting,Setting(name: .TermsPrivacy, imageName: "privacy"),Setting(name: .SendFeedback, imageName: "feedback"),Setting(name: .Help, imageName: "help"),Setting(name: .SwitchAccount, imageName: "account"),cancelSetting]
       
    }()
    
    var homeController:HomeController?
    
    func showSettings()
    {
        if let window = UIApplication.shared.keyWindow{
            
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height:CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            
            // 누르면 일단 화면 바로 밑에 height 만큼의 height의 컬렉션 뷰가 생성된다고 생각하면 될듯
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
 
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // 생성 후 올라오는 거지 blackview는 keywindow frame을 갖고 있는 상태고 animate를 통해 alpha 값을 갖게 됨 .curveEaseOut 을 쓰기 위해 withDuration만 갖고 있는 간단한 함수 대신 이 함수를 썼다
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)

        }
    }
    
    func handleDismiss(setting:Setting)
    {
//        UIView.animate(withDuration: 0.5) {
//            self.blackView.alpha = 0
//            
//            if let window = UIApplication.shared.keyWindow
//            {
//                //// 누르면 일단 화면 바로 밑으로 컬렉션 뷰가 내려간다고 생각하면 될듯
//                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//            }
//        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow
            {
                //// 누르면 일단 화면 바로 밑으로 컬렉션 뷰가 내려간다고 생각하면 될듯
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed) in
            
            
            if setting.name != .Cancel
            {
                
                self.homeController?.showControllerForSetting(setting: setting)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = self.settings[indexPath.item]
        cell.setting = setting
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting:setting)

    }
    
    override init() {
        super.init()
        
        // NSObject 만 상속받고 있을 땐 밑에 두 줄 오류 뜬다.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
}
