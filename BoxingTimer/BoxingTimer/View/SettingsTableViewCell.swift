//
//  SettingsTableViewCell.swift
//  BoxingTimer
//
//  Created by richard oh on 17/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    
    let textForMenu: UILabel = {
        let text = UILabel()
        text.textColor = .gray
        text.font = UIFont(name: "BebasNeue-Regular", size: 16)
        return text
    }()
    
    let bottomLineView: UIView = {
        let lv = UIView()
        lv.backgroundColor = .gray
        lv.alpha = 0.2
        return lv
    }()
    
    let minChangeIndicator: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "foward")
        imgView.isHidden = true
        return imgView
    }()
    
    let minChangeBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        return btn
    }()
    
    let secChangeIndicator: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "foward")
        imgView.isHidden = true
        return imgView
    }()
    
    let secChangeBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        return btn
    }()
   
    let totalRecordsTextLabel: UILabel = {
        let text = UILabel()
        text.textColor = .gray
        text.font = UIFont(name: "BebasNeue-Regular", size: 16)
        text.isHidden = true
        return text
    }()
    
    let deleteRecordBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("DELETE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 16)
        btn.layer.cornerRadius = 8.0
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.4, height: 2.5)
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 5.0
        return btn
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("Mail", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 16)
        btn.layer.cornerRadius = 8.0
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.4, height: 2.5)
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 5.0
        return btn
    }()
    
    let versionText: UILabel = {
        let vt = UILabel()
        vt.textColor = .gray
        vt.font = UIFont(name: "BebasNeue-Regular", size: 16)
        vt.isHidden = true
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String{
        vt.text = version
        }
        return vt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayout(){
        addSubview(textForMenu)
        addSubview(bottomLineView)
        
        addSubview(minChangeIndicator)
        addSubview(minChangeBtn)
        
        addSubview(secChangeIndicator)
        addSubview(secChangeBtn)
        
        addSubview(totalRecordsTextLabel)
        addSubview(deleteRecordBtn)
        
        addSubview(sendBtn)
        addSubview(versionText)
        
        textForMenu.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
        }
        
        minChangeIndicator.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview().offset(-1)
        }
        
        minChangeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secChangeIndicator.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview().offset(-1)
        }
        
        secChangeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        totalRecordsTextLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        deleteRecordBtn.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(35)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        sendBtn.snp.makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(35)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        versionText.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}
