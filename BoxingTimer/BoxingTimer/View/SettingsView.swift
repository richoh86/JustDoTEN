//
//  SettingsView.swift
//  BoxingTimer
//
//  Created by richard oh on 17/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import RxDataSources
import SnapKit

class SettingsView: UIView {

    let tableViewForSettings: UITableView = {
        let tView = UITableView()
        tView.tag = 2
        tView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        return tView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayout(){
        
        addSubview(tableViewForSettings)
        
        tableViewForSettings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
