//
//  ViewController.swift
//  BoxingTimer
//
//  Created by richard oh on 13/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import ReactorKit
import Then
import RxDataSources

import AVFoundation
import CloudKit
import MessageUI

// 저장시 라운드
var roundsForSave: Int = 0

class MainViewController: UIViewController, ReactorKit.View{
    
    typealias Reactor = MainReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Q&A email composeVC
    var mailVC: MFMailComposeViewController?
    
    // MARK: - Records Stream
    var records: PublishSubject<[Records]>?
    
    // MARK: - background mode
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Timer View
    var timer = Timer()
    
    var isStartBtnClicked = false
    
    var rounds = 1
    
    var counter = 180
    
    var counterForRound = 180
    var counterForRest = 30
    
    var startBell: AVAudioPlayer?
    var thirtySecBell: AVAudioPlayer?
    var doneBell: AVAudioPlayer?
    
    let timerBtnImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "timerMenu")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let timerMenuBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(timerMenuMoved), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    let timerLabel: UILabel = {
        let lb = UILabel()
        let text = "TIMER"
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        return lb
    }()
    
    let timerBar: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    let timerView: TimerView = {
        let tv = TimerView()
        tv.startBtn.addTarget(self, action: #selector(startBtnAction), for: UIControl.Event.touchUpInside)
        tv.resetBtn.addTarget(self, action: #selector(resetBtnAction), for: UIControl.Event.touchUpInside)
        tv.resetBtn.isEnabled = false
        tv.resetBtnView.alpha = 0.2
        return tv
    }()
    
    // MARK: - Records View
    var arrayOfRecords: [Records] = []
    var totalRounds: Int = 0
    var averageRounds: Int = 0
    
    let recordsBtnImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "recordsMenu")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        return imageView
    }()
    
    let recordsMenuBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(recordsMenuMoved), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    let recordsLabel: UILabel = {
        let lb = UILabel()
        let text = "RECORDS"
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        lb.textAlignment = .center
        lb.textColor = .black
        lb.alpha = 0.5
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        return lb
    }()
    
    let recordsBar: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.cornerRadius = 2.0
        view.isHidden = true
        return view
    }()
    
    let recordsView: RecordsView = {
        let rv = RecordsView()
        rv.isHidden = true
        return rv
    }()
    
    // MARK: - Settings View
    let settingsBtnImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingsMenu")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        return imageView
    }()
    
    let settingsMenuBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(settingsMenuMoved), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    let settingsLabel: UILabel = {
        let lb = UILabel()
        let text = "SETTINGS"
        lb.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 1.3])
        lb.textAlignment = .center
        lb.textColor = .black
        lb.alpha = 0.5
        lb.font = UIFont(name: "BebasNeue-Regular", size: 12)
        return lb
    }()
    
    let settingsBar: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9501903653, green: 0.2376204133, blue: 0.4596278071, alpha: 1)
        view.layer.cornerRadius = 2.0
        view.isHidden = true
        return view
    }()
    
    let settingsView: SettingsView = {
        let sv = SettingsView()
        sv.isHidden = true
        return sv
    }()
    
    init(reactor: Reactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        
        layoutUpdate()
        timerView.roundNumber.text = "\(rounds)"
        audioFileSetup()
        
        bindTableViewForRecords()
        
        setTotalRounds()
        setAverageRounds()
        
        bindTableViewForSettings()
        
        setMinSecFromUserDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordsView.tableViewForRecords
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        settingsView.tableViewForSettings
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Set UserDefault min & sec
    private func setMinSecFromUserDefaults(){
        if let min = UserDefaults.standard.value(forKey: "min") as? Int,
            let sec = UserDefaults.standard.value(forKey: "sec") as? Int{
            counterForRound = min
            counterForRest = sec
            counter = counterForRound
            if counterForRound == 180{
                self.timerView.timeNumber.text = "3:00"
            }else if counterForRound == 120{
                self.timerView.timeNumber.text = "2:00"
            }
        }else{
            counter = counterForRound
            if self.counterForRound == 180{
                self.timerView.timeNumber.text = "3:00"
            }else if self.counterForRound == 120{
                self.timerView.timeNumber.text = "2:00"
            }
        }
    }
    
    // MARK: - Total Rounds Cal.
    private func setTotalRounds(){
        
        guard arrayOfRecords.count != 0 else {return}
        
        for rNum in arrayOfRecords{
            totalRounds += rNum.round
        }
        recordsView.totalRoundNumber.text = "\(totalRounds)"
    }
    
    // MARK: - Average Rounds Cal.
    private func setAverageRounds(){
        
        guard arrayOfRecords.count != 0 else {return}
        
        averageRounds = totalRounds / arrayOfRecords.count
        recordsView.averageRoundNumber.text = "\(averageRounds)"
    }
    
    // MARK: - Timer Menu 이동
    @objc func timerMenuMoved(){
        
        timerBtnImg.alpha = 1.0
        timerLabel.alpha = 1.0
        timerBar.isHidden = false
        
        recordsBtnImg.alpha = 0.2
        recordsLabel.alpha = 0.2
        recordsBar.isHidden = true
        
        settingsBtnImg.alpha = 0.2
        settingsLabel.alpha = 0.2
        settingsBar.isHidden = true
        
        timerView.isHidden = false
        recordsView.isHidden = true
        settingsView.isHidden = true
        
    }
    
    // MARK: - Records Menu 이동
    @objc func recordsMenuMoved(){
        
        timerBtnImg.alpha = 0.2
        timerLabel.alpha = 0.2
        timerBar.isHidden = true
        
        recordsBtnImg.alpha = 1.0
        recordsLabel.alpha = 1.0
        recordsBar.isHidden = false
        
        settingsBtnImg.alpha = 0.2
        settingsLabel.alpha = 0.2
        settingsBar.isHidden = true
        
        timerView.isHidden = true
        recordsView.isHidden = false
        settingsView.isHidden = true
        
    }
    // MARK: - Setting Menu 이동
    @objc func settingsMenuMoved(){
        
        timerBtnImg.alpha = 0.2
        timerLabel.alpha = 0.2
        timerBar.isHidden = true
        
        recordsBtnImg.alpha = 0.2
        recordsLabel.alpha = 0.2
        recordsBar.isHidden = true
        
        settingsBtnImg.alpha = 1.0
        settingsLabel.alpha = 1.0
        settingsBar.isHidden = false
        
        timerView.isHidden = true
        recordsView.isHidden = true
        settingsView.isHidden = false
    }
    
    // MARK: - AudioFiles Setup
    private func audioFileSetup(){
        do {
            if let fileURL1 = Bundle.main.path(forResource: "boxingStartBell", ofType: "wav"),
                let fileURL2 = Bundle.main.path(forResource: "thirtySecBell", ofType: "mp3"),
                let fileURL3 = Bundle.main.path(forResource: "doneBell", ofType: "flac"){
                startBell = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL1))
                thirtySecBell = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL2))
                doneBell = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL3))
            }else{
                print("No file with specified name exist")
            }
        }catch let error{
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Start Button Action
    @objc func startBtnAction(_ sender: UIButton){
        
        if isStartBtnClicked == false {
            
            startBell?.play()
            startBell?.numberOfLoops = 0
            
            timerView.startBtnLb.text = "PAUSE"
            isStartBtnClicked = true
            
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(runTimer),
                                         userInfo: nil,
                                         repeats: true)
            
            // register background mode
            registerBackgroundTask()
            
            // PAUSE 상태에서는 RESET 버튼 사용 불가능!
            timerView.resetBtn.isEnabled = false
            timerView.resetBtnView.alpha = 0.2
            
        }else{
            
            timerView.startBtnLb.text = "START"
            isStartBtnClicked = false
            timer.invalidate()
            
            // 백그라운드 테스크가 끝났다고 다시 알려줌
            if backgroundTask != .invalid {
                endBackgroundTask()
            }
            
            // START 상태에서는 RESET 버튼 사용 가능!
            timerView.resetBtn.isEnabled = true
            timerView.resetBtnView.alpha = 1.0
        }
    }
    
    // MARK: - Timer가 구동되는 함수
    @objc func runTimer(){
        
        // 10 라운드가 종료되면 바로 alert 창을 띄어 준다
        if rounds == 10, counter == 0, timerView.textForTimer.text == "BREAK" {
            timer.invalidate()
            rounds = 0
            
            let alertVC = UIAlertController(title: "Done", message: "Good Job!!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { (action) in
                
                if let counterForRound = UserDefaults.standard.value(forKey: "min") as? Int{
                    self.counter = counterForRound
                }else{
                    self.counter = self.counterForRound
                }
                
                // setting에서 변경시 텍스트도 함께 변경
                if self.counter == 180{
                    self.timerView.timeNumber.text = "3:00"
                } else if self.counter == 120{
                    self.timerView.timeNumber.text = "2:00"
                }
                
                self.timerView.textForTimer.text = "TIMER"
                self.timerView.roundNumber.text = "\(1)"
                
                self.timerView.startBtnLb.text = "START"
                self.isStartBtnClicked = false
                
                // 백그라운드 테스크가 끝났다고 다시 알려줌
                if self.backgroundTask != .invalid {
                    self.endBackgroundTask()
                }
                
                // START 상태에서는 RESET 버튼 사용 가능!
                self.timerView.resetBtn.isEnabled = true
                self.timerView.resetBtnView.alpha = 1.0
            }
            
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        // 30초 남았을 때 알림 사운드를 준다
        if counter == 30 {
            thirtySecBell?.play()
            thirtySecBell?.numberOfLoops = 0
        }
        
        // Break Timer 종료
        // 0:00이 되면 다시 3:00으로 변경
        // Round 숫자 증가
        if counter == 0, timerView.textForTimer.text == "BREAK" {
            
            if let counterForRound = UserDefaults.standard.value(forKey: "min") as? Int{
                counter = counterForRound
            }else{
                counter = self.counterForRound
            }
            
            if rounds != 10{
                rounds += 1
            }
            timerView.roundNumber.text = "\(rounds)"
            timerView.textForTimer.text = "TIMER"
            doneBell?.play()
            doneBell?.numberOfLoops = 0
        }
        
        // Break Time 시작
        // 만약 0:00인데 BREAK가 아닌 경우
        // 30초를 BREAK TIME으로 준다
        if counter == 0, timerView.textForTimer.text != "BREAK"  {
            
            if let counterForRest = UserDefaults.standard.value(forKey: "sec") as? Int{
                counter = counterForRest
            }else{
                counter = self.counterForRest
            }
            
            timerView.textForTimer.text = "BREAK"
            startBell?.play()
            startBell?.numberOfLoops = 0
            // 저장용
            if rounds > 0 {
                roundsForSave = rounds
            }
        }
        
        // 기본 로직
        // 1. 1초씩 감소
        // 2. 분은 60으로 나눈 값
        // 3. 초는 60으로 나눈 나머지 값
        counter -= 1
        
        let min = counter / 60
        let sec = counter % 60
        
        if sec < 10 {
            timerView.timeNumber.text = "\(min):0\(sec)"
        }else{
            timerView.timeNumber.text = "\(min):\(sec)"
        }
        
    }
    
    // MARK: - Reset Button 함수
    @objc func resetBtnAction(_ sender: UIButton){
        
        counter = self.counterForRound
        timer.invalidate()
        
        if self.counterForRound == 180 {
            timerView.timeNumber.text = "3:00"
        }else if self.counterForRound == 120 {
            timerView.timeNumber.text = "2:00"
        }
        
        timerView.textForTimer.text = "TIMER"
        
    }
    
    // MARK: - Get Data from UserDefaults
    func getDataForTableView() -> [Records] {
        if let arrayOfRecords = UserDefaults.standard.value(forKey: "Records") as? [[String: Any]]{
            for recordData in arrayOfRecords{
                if let  dayOfTheWeek = recordData["dayOfTheWeek"] as? String,
                    let currentDate = recordData["currentDate"] as? String,
                    let rounds = recordData["rounds"] as? Int{
                    let record = Records(dayOfTheWeek: dayOfTheWeek, date: currentDate, round: rounds)
                    self.arrayOfRecords.append(record)
                }
            }
        }
        return self.arrayOfRecords
    }
    
    
    // MARK: - Data Bind To TableView of RecordsView
    private func bindTableViewForRecords(){
        
        // 1. 초기화
        records = PublishSubject<[Records]>()
        
        // 2. 바인드 to tableview
            records?
                .bind(to: recordsView.tableViewForRecords.rx.items){
                (tableView: UITableView, index: Int, element: Records) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecordsTableViewCell
                cell.dayOfTheWeek.text = element.dayOfTheWeek
                cell.date.text = element.date
                cell.round.text = "\(element.round) ROUNDS"
                return cell
            }
            .disposed(by: disposeBag)
        
        // 3. 데이터를 스트림에 넣어주는 작업
        records?.onNext(self.getDataForTableView())
    }
    
    // MARK: - Data bind to TableView of SettingsView
    private func bindTableViewForSettings(){
        
        // configureCell
        let configureCell: (TableViewSectionedDataSource<SectionModel<String, String>>,
            UITableView, IndexPath, String) -> UITableViewCell = {
                
                (datasource, tableView, indexPath, elements) in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingsTableViewCell  else { return UITableViewCell() }
                let section = indexPath.section
                let row = indexPath.row
                
                switch (section, row) {
                case (0, 0):
                    cell.minChangeIndicator.isHidden = false
                    cell.minChangeBtn.isHidden = false
                    cell.minChangeBtn.addTarget(self, action: #selector(self.changeMin), for: .touchUpInside)
                case (0, 1):
                    cell.secChangeIndicator.isHidden = false
                    cell.secChangeBtn.isHidden = false
                    cell.secChangeBtn.addTarget(self, action: #selector(self.changeSec), for:.touchUpInside)
                case (1, 0):
                    cell.totalRecordsTextLabel.isHidden = false
                    cell.totalRecordsTextLabel.text = "\(self.arrayOfRecords.count)"
                case (1, 1):
                    cell.deleteRecordBtn.isHidden = false
                    cell.deleteRecordBtn.addTarget(self, action: #selector(self.deleteRecords), for: .touchUpInside)
                case (2, 0):
                    cell.sendBtn.isHidden = false
                    cell.sendBtn.addTarget(self, action: #selector(self.sendEmail), for: .touchUpInside)
                case (2, 1):
                    cell.versionText.isHidden = false
                default:
                    break
                }
                
                cell.textForMenu.text = elements
                cell.selectionStyle = .none
                return cell
        }
        
        // datasource
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: configureCell)
        
        datasource.titleForHeaderInSection = { dataSource, index in
            return datasource.sectionModels[index].model
        }
        
        // section data
        let timerMenus = ["min. per round", "sec. for break"]
        let recordsMenus = ["total records","delete all records"]
        let moreMenus = ["Q & A", "version"]
        
        let sections = [
            SectionModel<String, String>(model: "TIMER", items: timerMenus),
            SectionModel<String, String>(model: "RECORD", items: recordsMenus),
            SectionModel<String, String>(model: "MORE", items: moreMenus)
        ]
        
        // bind to SettingView's tableView
        Observable.just(sections)
            .bind(to: settingsView.tableViewForSettings.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - AutoLayout
    private func layoutUpdate(){
        
        view.backgroundColor = .white
        
        view.addSubview(timerBtnImg)
        view.addSubview(timerLabel)
        view.addSubview(timerBar)
        view.addSubview(timerMenuBtn)
        
        view.addSubview(recordsBtnImg)
        view.addSubview(recordsLabel)
        view.addSubview(recordsBar)
        view.addSubview(recordsMenuBtn)
        
        view.addSubview(settingsBtnImg)
        view.addSubview(settingsLabel)
        view.addSubview(settingsBar)
        view.addSubview(settingsMenuBtn)
        
        view.addSubview(timerView)
        view.addSubview(recordsView)
        view.addSubview(settingsView)
        
        timerBtnImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.right.equalTo(recordsBtnImg.snp.left).offset(-100)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.top.equalTo(timerBtnImg.snp.bottom).offset(10)
            make.centerX.equalTo(timerBtnImg.snp.centerX)
        }
        
        timerBar.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(5)
            make.width.equalTo(15)
            make.height.equalTo(5)
            make.centerX.equalTo(timerLabel.snp.centerX)
        }
        
        timerMenuBtn.snp.makeConstraints { make in
            make.width.equalTo(timerBtnImg.snp.width).offset(50)
            make.height.equalTo(timerBtnImg.snp.height).offset(50)
            make.center.equalTo(timerBtnImg.snp.center)
        }
        
        recordsBtnImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        recordsLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.top.equalTo(recordsBtnImg.snp.bottom).offset(10)
            make.centerX.equalTo(recordsBtnImg.snp.centerX)
        }
        
        recordsMenuBtn.snp.makeConstraints { make in
            make.width.equalTo(recordsBtnImg.snp.width).offset(50)
            make.height.equalTo(recordsBtnImg.snp.height).offset(50)
            make.center.equalTo(recordsBtnImg.snp.center)
        }
        
        recordsBar.snp.makeConstraints { make in
            make.top.equalTo(recordsLabel.snp.bottom).offset(5)
            make.width.equalTo(15)
            make.height.equalTo(5)
            make.centerX.equalTo(recordsLabel.snp.centerX)
        }
        
        settingsBtnImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.left.equalTo(recordsBtnImg.snp.right).offset(100)
        }
        
        settingsLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.top.equalTo(settingsBtnImg.snp.bottom).offset(10)
            make.centerX.equalTo(settingsBtnImg.snp.centerX)
        }
        
        settingsBar.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(5)
            make.width.equalTo(15)
            make.height.equalTo(5)
            make.centerX.equalTo(settingsLabel.snp.centerX)
        }
        
        settingsMenuBtn.snp.makeConstraints { make in
            make.width.equalTo(settingsBtnImg.snp.width).offset(50)
            make.height.equalTo(settingsBtnImg.snp.height).offset(50)
            make.center.equalTo(settingsBtnImg.snp.center)
        }
        
        timerView.snp.makeConstraints { make in
            make.top.equalTo(timerBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        recordsView.snp.makeConstraints { make in
            make.top.equalTo(timerBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(timerBar.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    func bind(reactor: Reactor){
        
    }
    
}
extension MainViewController: UITableViewDelegate {
    // MARK: - tableView heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = recordsView.tableViewForRecords.indexPathForSelectedRow{
            recordsView.tableViewForRecords.deselectRow(at: index, animated: true)
        }
        
        if let index = settingsView.tableViewForSettings.indexPathForSelectedRow{
            settingsView.tableViewForSettings.deselectRow(at: index, animated: true)
        }
    }
    
    // go back to initialState
    private func initialState(){
        timerView.startBtnLb.text = "START"
        isStartBtnClicked = false
        
        // 백그라운드 테스크가 끝났다고 다시 알려줌
        if backgroundTask != .invalid {
            endBackgroundTask()
        }
        
        // START 상태에서는 RESET 버튼 사용 가능!
        timerView.resetBtn.isEnabled = true
        timerView.resetBtnView.alpha = 1.0
    }
    
    // alerVC to change minutes
    @objc func changeMin(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "2 minutes", style: .default) { (action) in
            if self.timer.isValid == true {
                self.timer.invalidate()
                self.initialState()
            }
            self.timerView.timeNumber.text = "2:00"
            self.counterForRound = 120
            self.counter = self.counterForRound
            UserDefaults.standard.set(self.counterForRound, forKey: "min")
        }
        let action2 = UIAlertAction(title: "3 minutes", style: .default) { (action) in
            if self.timer.isValid == true {
                self.timer.invalidate()
                self.initialState()
            }
            self.timerView.timeNumber.text = "3:00"
            self.counterForRound = 180
            self.counter = self.counterForRound
            UserDefaults.standard.set(self.counterForRound, forKey: "min")
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // alerVC to change seconds
    @objc func changeSec(){
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "20 seconds", style: .default) { (action) in
            if self.timer.isValid == true {
                self.timer.invalidate()
                self.initialState()
            }
            self.counterForRest = 20
            UserDefaults.standard.set(self.counterForRest, forKey: "sec")
        }
        let action2 = UIAlertAction(title: "30 seconds", style: .default) { (action) in
            if self.timer.isValid == true {
                self.timer.invalidate()
                self.initialState()
            }
            self.counterForRest = 30
            UserDefaults.standard.set(self.counterForRest, forKey: "sec")
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tag = tableView.tag
        switch (tag, section) {
        case (1, 0):
            let headerView = HeaderViewForSettings(image: UIImage(named: "recordForRecords")!)
            let title = "RECORDS"
            headerView.titleLabel.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 1.0])
            return headerView
        case (2, 0):
            let headerView = HeaderViewForSettings(image: UIImage(named: "timeForTimer")!)
            let title = "TIMER"
            headerView.titleLabel.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 1.0])
            return headerView
        case (2, 1):
            let headerView = HeaderViewForSettings(image: UIImage(named: "recordForRecords")!)
            let title = "RECORDS"
            headerView.titleLabel.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 1.0])
            return headerView
        case (2, 2):
            let headerView = HeaderViewForSettings(image: UIImage(named: "infoForSettings")!)
            let title = "MORE"
            headerView.titleLabel.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 1.0])
            return headerView
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
}


// MARK: - setting view actions
extension MainViewController: MFMailComposeViewControllerDelegate {
    
    @objc func deleteRecords(){
        
        let alertVC = UIAlertController(title: "Caution", message: "Do you really want to delete all your records?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            // 1. UserDefault의 array 값을 초기화
            let arrayOfRecords: [[String: Any]] = []
            UserDefaults.standard.set(arrayOfRecords, forKey: "Records")
            
            // 2. arrayOfRecords 값을 초기화
            self.arrayOfRecords.removeAll()
            
            // 3. data 호출 및 records 스트림에 이벤트를 넣어준다
            self.records?.onNext(self.getDataForTableView())
            
            // 4. totalRound = 0
            self.recordsView.totalRoundNumber.text = "\(0)"
            
            // 5. averageRound = 0
            self.recordsView.averageRoundNumber.text = "\(0)"
            
            // 6. totalRecords = 0
            self.settingsView.tableViewForSettings.reloadData()
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @objc func sendEmail(){
        guard MFMailComposeViewController.canSendMail() else {return}

        mailVC = MFMailComposeViewController()
        mailVC?.mailComposeDelegate = self
        mailVC?.setToRecipients(["richohios@gmail.com"])

        self.present(mailVC!, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailVC?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - background mode setting
extension MainViewController{
    
    //2. Register the task
    @objc func registerBackgroundTask(){
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        assert(backgroundTask != .invalid)
    }
    
    //3. End the task
    func endBackgroundTask(){
        print("Background Task ended")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    // To register observer
    @objc func reinstateBackgroundTask(){
        if timer.isValid == true && (backgroundTask == .invalid){
            registerBackgroundTask()
        }
    }

}
