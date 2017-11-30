//
//  SettingViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class SettingViewController: FormViewController {
    
    let userDefaults = UserDefaults.standard
    var groups = [Group]()
    var preTeam = ""

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "設定"
        builder += SectionHeaderTitleFormItem().title("Token登録")
        builder += tokenKeyViewControllerForm
        builder += SectionHeaderTitleFormItem().title("OPTION")
        builder += groupListPiker
        builder += teamNameTextForm
        builder += SectionHeaderTitleFormItem().title("APP INFO")
        builder += StaticTextFormItem().title("Version").value(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        getGroupList()
        updateForm()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGroupList()
        updateForm()
        updateGroupPicker(groupListPiker)
    }
    
    lazy var tokenKeyViewControllerForm: ViewControllerFormItem = {
        return ViewControllerFormItem().viewController(RegisterTokenKeyViewController.self)
    }()
    
    
    lazy var teamNameTextForm: StaticTextFormItem = {
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            preTeam = selectedTeam
        }
        return StaticTextFormItem().title("所属チーム情報")
    }()
    
    lazy var groupListPiker: OptionPickerFormItem = {
        let instance = OptionPickerFormItem()
        instance.title("勤怠管理グループ設定")
        ACAGroupRequest().getGroupList { groupList in
            if let groupList = groupList {
                DispatchQueue.main.async {
                    for group in groupList {
                        instance.append(group.name)
                    }
                }
            }
        }
        
        if let selectedGroup = userDefaults.object(forKey: "SelectedGroup") as? String {
            instance.placeholder(selectedGroup)
            
        }
        instance.valueDidChange = { (selected: OptionRowModel?) in
            self.userDefaults.set(selected?.title, forKey: "SelectedGroup")
        }
        
        return instance
    }()
    
    func updateForm() {
        
        if let tokenKey = userDefaults.object(forKey: "paramTokenKey") as? String {
            tokenKeyViewControllerForm.title("\(tokenKey)")
        } else {
            tokenKeyViewControllerForm.title = "TokenKeyを登録してください。"
        }
        
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            teamNameTextForm.value = "\(selectedTeam)"
        } else {
            teamNameTextForm.value = "None"
        }
    }
    
    func updateGroupPicker(_ picker: OptionPickerFormItem) {
        let currentTeam = userDefaults.object(forKey: "selectedTeam") as? String
        
        if let currentTeam = currentTeam {
            if preTeam != currentTeam {
                picker.selected = nil
                picker.placeholder = ""
                preTeam = currentTeam
            }
            picker.options.removeAll()
            for group in groups {
                picker.append(group.name)
            }
        } else {
            picker.options.removeAll()
            picker.placeholder = ""
        }
        
    }
    
    func getGroupList() {
        var groups = [Group]()
        ACAGroupRequest().getGroupList { groupList in
            if let groupList = groupList {
                for group in groupList {
                    groups.append(group)
                }
            }
            DispatchQueue.main.async {
                self.groups = groups
            }
        }
    }

}
