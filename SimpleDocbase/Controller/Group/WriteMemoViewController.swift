//
//  WriteMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/02.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

protocol WriteMemoViewControllerDelegate {
    func writeMemoViewSubmit()
}

class WriteMemoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    var delegate: WriteMemoViewControllerDelegate?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var groups = [Group]()
    var groupId: Int = 0
    
    var checkWriteSuccess = false
    
    
    // MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    // MARK: IBActions
    @IBAction func submitMemoButton(_ sender: Any) {
        
        var tags = [String]()
        guard let tagsText:String = tagsTextField.text else { return }
        let tagArr = tagsText.components(separatedBy: ",")
        
        for tag in tagArr{
            let trimTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
            tags.append(trimTag)
        }
        
        let memo: [String : Any] = [
            "title": titleTextField.text ?? "" ,
            "body": bodyTextView.text ?? "" ,
            "draft": false,
            "tags": tags,
            "scope": "group",
            "groups": [groupId],
            "notice": true
        ]

        if let domain = domain {
           
            
            // 여기서 참 거짓 확인해서 얼럿 띄우고 딜리게이트 보내면 될까?
            DispatchQueue.global().async {
                ACAMemoRequest().writeMemo(domain: domain, dict: memo) { check in
                    if check == true {
                        self.checkWriteSuccess = true
                    }
                }
                DispatchQueue.main.async {
                    
                    if self.checkWriteSuccess == true {
                        self.delegate?.writeMemoViewSubmit()
                    } else {
                        
                    }
                    
                }
                
            }
            
        }
        
        func checkWriteSuccessAlert(result: String) {
            let ac = UIAlertController(title: result, message: nil, preferredStyle: .alert)
        
            if result == "Success" {
                let successAction = UIAlertAction(title: "TokenKey登録", style: .default) { action in
                    print("Write Memo Success")
                    
                }
                ac.addAction(successAction)
                
                } else {
                let failAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) {
                    (action: UIAlertAction!) -> Void in
                    print("Write Memo Faill")
                }
                ac.addAction(failAction)
            }
            
            self.present(ac, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
        
        ACAGroupRequest().getGroupList { groups in
            if let groups = groups {
                self.groups = groups
            }
            DispatchQueue.main.async {
                self.groupPickerView.reloadAllComponents()
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupId = groups[row].id
    }
}
