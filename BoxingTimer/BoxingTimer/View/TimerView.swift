//
//  TimerView.swift
//  BoxingTimer
//
//  Created by richard oh on 13/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    let circleForRounds: UIView = {
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
    
    let textForRound: UILabel = {
        let lb = UILabel()
        
        let text = "ROUND"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.0])
        
        return lb
    }()
    
    let roundNumber: UILabel = {
        let lb = UILabel()
        lb.text = "1"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 30)
        return lb
    }()
    
    let circleForTimer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 110
        view.backgroundColor = .none
        
        view.layer.borderColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.borderWidth = 8.0
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 4.0); //Here your control your spread
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5.0
        
        return view
    }()
    
    let textForTimer: UILabel = {
        let lb = UILabel()
        let text = "TIMER"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.0])
        return lb
    }()
    
    let timeNumber: UILabel = {
        let lb = UILabel()
//        let text = "3:00"
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 60)
//        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        return lb
    }()
    
    let startBtnLb: UILabel = {
        let lb = UILabel()
        let text = "START"
        lb.textAlignment = .center
        lb.textColor = .white
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        lb.font = UIFont(name: "BebasNeue-Regular", size: 27)
        return lb
    }()
    
    let startBtnView: UIView = {
        let btnView = UIView()
        btnView.backgroundColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        btnView.layer.cornerRadius = 10
        
        btnView.layer.shadowColor = UIColor.black.cgColor
        btnView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0); //Here your control your spread
        btnView.layer.shadowOpacity = 0.5
        btnView.layer.shadowRadius = 5.0
        return btnView
    }()
    
    let startBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let resetBtnLb: UILabel = {
        let lb = UILabel()
        let text = "RESET"
        lb.textAlignment = .center
        lb.textColor = .white
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        lb.font = UIFont(name: "BebasNeue-Regular", size: 27)
        return lb
    }()
    
    let resetBtnView: UIView = {
        let btnView = UIView()
        btnView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        btnView.layer.cornerRadius = 10
        
        btnView.layer.shadowColor = UIColor.black.cgColor
        btnView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0); //Here your control your spread
        btnView.layer.shadowOpacity = 0.5
        btnView.layer.shadowRadius = 5.0
        return btnView
    }()
    
    let resetBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUpdate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - autolayout settings
    private func layoutUpdate(){
        
        addSubview(circleForRounds)
        addSubview(textForRound)
        addSubview(roundNumber)
        
        addSubview(circleForTimer)
        addSubview(textForTimer)
        addSubview(timeNumber)
        
        addSubview(startBtnView)
        addSubview(startBtnLb)
        addSubview(startBtn)
        
        addSubview(resetBtnView)
        addSubview(resetBtnLb)
        addSubview(resetBtn)
        
        circleForRounds.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-250)
        }
        
        roundNumber.snp.makeConstraints { make in
            make.centerX.equalTo(circleForRounds.snp.centerX)
            make.centerY.equalTo(circleForRounds.snp.centerY).offset(8)
        }
        
        textForRound.snp.makeConstraints { make in
            make.centerX.equalTo(circleForRounds.snp.centerX)
            make.centerY.equalTo(circleForRounds.snp.centerY).offset(-20)
        }
        
        circleForTimer.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(220)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        timeNumber.snp.makeConstraints { make in
            make.centerX.equalTo(circleForTimer.snp.centerX)
            make.centerY.equalTo(circleForTimer.snp.centerY).offset(8)
        }
        
        textForTimer.snp.makeConstraints { make in
            make.centerX.equalTo(circleForTimer.snp.centerX)
            make.centerY.equalTo(circleForTimer.snp.centerY).offset(-45)
        }
        
        startBtnView.snp.makeConstraints { make in
            make.width.equalTo(123)
            make.height.equalTo(49)
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview().offset(-80)
        }
        
        startBtnLb.snp.makeConstraints { make in
            make.width.equalTo(startBtnView.snp.width)
            make.height.equalTo(startBtnView.snp.height)
            make.center.equalTo(startBtnView.snp.center)
        }
        
        startBtn.snp.makeConstraints { make in
            make.edges.equalTo(startBtnView.snp.edges)
            make.center.equalTo(startBtnView.snp.center)
        }
        
        resetBtnView.snp.makeConstraints { make in
            make.width.equalTo(123)
            make.height.equalTo(49)
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview().offset(80)
        }
        
        resetBtnLb.snp.makeConstraints { make in
            make.width.equalTo(resetBtnView.snp.width)
            make.height.equalTo(resetBtnView.snp.height)
            make.center.equalTo(resetBtnView.snp.center)
        }
        
        resetBtn.snp.makeConstraints { make in
            make.edges.equalTo(resetBtnView.snp.edges)
            make.center.equalTo(resetBtnView.snp.center)
        }

        
    }

}
