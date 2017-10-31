//
//  Request.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/27.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

protocol RequestDelegate {
    func didRecivedTeamList(teams: Array<String>)
}

class Request {
    
    // MARK: Properties
    let session: URLSession = URLSession.shared
    var delegate: RequestDelegate?
    var teamDomain: String?
    var teamDomains = [String]()
    var groupNames = [String]()
    
    //FIXME: 後で設定から直接Keyを貰えるようにする。
    var tokenKey: String = "beNCf4mxkKXLLRrBqEwH"
    
    enum MethodType: String {
        case get = "GET", post = "POST", delete = "DELETE", put = "PUT", patch = "PATCH"
    }
    
    // MARK: Internal Methods
    func getTeamList() {
        
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
    
        let request = settingRequest(url: url, httpMethod: .get)
    
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        
                        if let teamList = TeamList(dict: json) {
                            
                            guard let delegate = self.delegate else {
                                return;
                            }
                            
                            self.delegate?.didRecivedTeamList(teams: teamList.teams)
                            
                        }
                    }
                } catch {
                print(error)
                }
            }
        }.resume()
        
    }
    
    func groupList(domain: String) -> Void {
        
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        
                        if let groupList = GroupList(dict: json) {
                            let names = groupList.groups
                            
                            self.groupNames = names
                            
                        }
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    
    // MARK: Private Methods
    private func settingRequest(url: URL, httpMethod: MethodType) -> URLRequest {
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(tokenKey, forHTTPHeaderField: "X-DocBaseToken")
        
        return request
    }
    
}