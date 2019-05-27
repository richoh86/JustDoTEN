//
//  HeaderViewForSettings.swift
//  BoxingTimer
//
//  Created by richard oh on 17/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import SnapKit

class HeaderViewForSettings: UIView {

    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 25)
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(image: UIImage){
        let frame = CGRect(x: 0, y: 0, width: 300, height: 65)
        super.init(frame: frame)
        self.imageView.image = image
        updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayout(){
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalTo(imageView.snp.centerY).offset(1)
        }
        
    }
}
