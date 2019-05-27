//
//  Records.swift
//  BoxingTimer
//
//  Created by richard oh on 15/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation

struct Records {
    
    let dayOfTheWeek: String
    let date: String
    
    let round: Int
    
    init(dayOfTheWeek: String, date: String, round: Int) {
        self.dayOfTheWeek = dayOfTheWeek
        self.date = date
        self.round = round
        
        fetchCloudKitData()
    }
    
    private func fetchCloudKitData(){
        
        
        
    }
}
