//
//  AppDelegate.swift
//  BoxingTimer
//
//  Created by richard oh on 13/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 3.0)

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainReactor = MainReactor()
        let mainVC = MainViewController(reactor: mainReactor)
        
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        saveDataToCloud()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        saveDataToCloud()
        saveToUserDefault()
    }
    
    func saveToUserDefault(){
        print(roundsForSave)
        
        // 0인 경우에는 라운드를 종료하지 않은것으로 간주
        // UserDefault에 데이터를 저장하지 않는다
        if roundsForSave > 0 {
            
            let date = Date()
            
            // 요일
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "EEEE"
            let dayOfTheWeekStr = dateFormatter1.string(from: date).capitalized
            
            // 날짜
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let currentDateStr = dateFormatter2.string(from: date)
            
            let dayOfTheWeek: String = dayOfTheWeekStr
            let currentDate: String = currentDateStr
            let rounds = roundsForSave
            
            print(dayOfTheWeek, currentDate, rounds)
            
            var recordsArray: [[String: Any]] = []
            let recordDic = ["dayOfTheWeek": dayOfTheWeek, "currentDate": currentDate, "rounds": rounds] as [String: Any]
            
            if var recordsArray = UserDefaults.standard.value(forKey: "Records") as? [[String: Any]]{
                print(recordsArray)
                recordsArray.append(recordDic)
                print(recordsArray)
                UserDefaults.standard.set(recordsArray, forKey: "Records")
                print("기존 배열에 추가 및 저장")
            }else{
                recordsArray.append(recordDic)
                UserDefaults.standard.set(recordsArray, forKey: "Records")
                print("첫 기록 저장")
            }
        }
    }

    // Cloud 저장은 종료될때 실행시키는 경우 저장이 안되는 현상이 자주 발생한다
    // 따라서, UserDefaults에 저장시킨 후 다시 불러와서 사용하는 것으로 대체한다
    func saveDataToCloud() {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print(roundsForSave)
        
        // 0인 경우에는 라운드를 종료하지 않은것으로 간주
        // 클라우드에 데이터를 저장하지 않는다
        if roundsForSave > 0 {
            
            let date = Date()
            let database = CKContainer.default().privateCloudDatabase
            
            // 요일
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "EEEE"
            let dayOfTheWeekStr = dateFormatter1.string(from: date).capitalized
            
            // 날짜
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateStyle = .long
            let currentDateStr = dateFormatter2.string(from: date)
            
            let dayOfTheWeek: String = dayOfTheWeekStr
            let currentDate: String = currentDateStr
            let rounds = roundsForSave
            
            let dic = ["dayOfTheWeek": dayOfTheWeek, "currentDate": currentDate, "rounds": rounds] as [String : Any]
            let record = CKRecord(recordType: "Records")
            
            record.setValuesForKeys(dic)
            
            print(record)
            print("저장 실행 시작")
            DispatchQueue.main.async {
                database.save(record) { r, error in
                    if let err = error {
                        print(err.localizedDescription)
                    }else{
                        print("save completed!")
                    }
                }
            }
            
            
        }
    }
    
    


}

