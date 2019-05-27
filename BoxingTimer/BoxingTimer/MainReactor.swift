//
//  MainReactor.swift
//  BoxingTimer
//
//  Created by richard oh on 13/05/2019.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

class MainReactor: ReactorKit.Reactor {
 
    enum Action {
        case none
    }
    
    enum Mutation {
        case none
    }
    
    struct State {
    }
    
    let initialState = MainReactor.State()
    
    func mutate(action: MainReactor.Action) -> Observable<MainReactor.Mutation> {
        return Observable.just(Mutation.none)
    }
    
    func reduce(state: MainReactor.State, mutation: MainReactor.Mutation) -> MainReactor.State {
        let state = state
        return state
    }
    
}
