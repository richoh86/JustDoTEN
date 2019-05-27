//
//  RecordsTableViewCell.swift
//  BoxingTimer
//
//  Created by richard oh on 15/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import SnapKit

class RecordsTableViewCell: UITableViewCell {
    
    var dayOfTheWeek: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
       lb.font = UIFont(name: "BebasNeue-Regular", size: 14)
       return lb
    }()
    
    var date: UILabel = {
        let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont(name: "BebasNeue-Regular", size: 14)
        return lb
    }()

    var round: UILabel = {
        let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont(name: "BebasNeue-Regular", size: 14)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       updateLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayout(){
        
        addSubview(dayOfTheWeek)
        addSubview(date)
        addSubview(round)
        
        dayOfTheWeek.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
        }
        
        date.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
        }

        round.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
}
