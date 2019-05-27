//
//  RecordsView.swift
//  BoxingTimer
//
//  Created by richard oh on 15/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RecordsView: UIView {
    
    let tableViewForRecords: UITableView = {
        let tv = UITableView()
        tv.tag = 1
        tv.register(RecordsTableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    let circleForTotalRounds: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .none
        
        view.layer.borderColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.borderWidth = 8.0
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5.0
        
        return view
    }()
    
    let textForTotalRound: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        let text = "TOTAL\nROUNDS"
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.0])
        
        return lb
    }()
    
    let totalRoundNumber: UILabel = {
        let lb = UILabel()
        lb.text = "0"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 30)
        return lb
    }()
    
    let circleForAverageRounds: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .none
        
        view.layer.borderColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.borderWidth = 8.0
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5.0
        
        return view
    }()
    
    let textForAverageRound: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        let text = "AVERAGE\nROUNDS"
        lb.textColor = .black
        lb.textAlignment = .center
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.0])
        
        return lb
    }()
    
    let averageRoundNumber: UILabel = {
        let lb = UILabel()
        lb.text = "0"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 30)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUpdate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUpdate(){
        
        addSubview(circleForTotalRounds)
        addSubview(textForTotalRound)
        addSubview(totalRoundNumber)
        
        addSubview(circleForAverageRounds)
        addSubview(textForAverageRound)
        addSubview(averageRoundNumber)
        
        addSubview(tableViewForRecords)
        
        circleForTotalRounds.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview().offset(-70)
            make.centerY.equalToSuperview().offset(-250)
        }
        
        textForTotalRound.snp.makeConstraints { make in
            make.centerX.equalTo(circleForTotalRounds.snp.centerX)
            make.centerY.equalTo(circleForTotalRounds.snp.centerY).offset(80)
        }
        
        totalRoundNumber.snp.makeConstraints { make in
            make.center.equalTo(circleForTotalRounds.snp.center)
        }
        
        circleForAverageRounds.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview().offset(70)
            make.centerY.equalToSuperview().offset(-250)
        }
        
        textForAverageRound.snp.makeConstraints { make in
            make.centerX.equalTo(circleForAverageRounds.snp.centerX)
            make.centerY.equalTo(circleForAverageRounds.snp.centerY).offset(80)
        }
        
        averageRoundNumber.snp.makeConstraints { make in
            make.center.equalTo(circleForAverageRounds.snp.center)
        }
        
        tableViewForRecords.snp.makeConstraints { make in
            make.top.equalTo(circleForAverageRounds.snp.bottom).offset(80)
            make.left.right.bottom.equalToSuperview()
        }
    }
   
}
