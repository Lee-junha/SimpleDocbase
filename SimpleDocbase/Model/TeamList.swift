//
//  TeamList.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/27.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

struct TeamList {
    var teams = [String]()
    
    init?(dict: [[String: String]]) {
        
        for team in dict {
            if let team = Team(team:team) {
                
                teams.append(team.domain)
            }
        }
    }
}


