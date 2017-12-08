//
//  SheetViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/07.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

final class SheetViewController : UIViewController {

    // MARK: Properties
    var workSheets = [WorkSheet]()
    var selectedWorkSheet : WorkSheet?
    var groups: [Group] = []
    
    let worksheetManager = WorkSheetManager.sharedManager
    
    // MARK: IBOutlets
    @IBOutlet weak var sheetTableView: UITableView?
    @IBOutlet weak var messageLabel: UILabel?
    
    // MARK: IBActions
    
    // MARK: Initializer
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "勤怠管理"
        
        initControls()
        
        // Do any additional setup after loading the view.
        //REMARK: テストデータ
//        loadTestData()

     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertWorkSheetAferloadLoaclWorkSheet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Actinos
    @objc func addSheetButtonTouched(_ sender: UIBarButtonItem) {
        
        print("addSheetButtonTouched!!")
        
        let alert = UIAlertController(title:"勤務表追加",
                                      message: "作成する年月を入力してください。",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "YYYYMM"
        }

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler:nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            print("OK")

            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    //TODO: 6桁数字なのかをチェック
                    if textField.text?.count != 6 {
                        let alert = UIAlertController(title:"勤務表追加失敗",
                                                      message: "YYYYMMの形式で入力してください。",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK",
                                                      style: .cancel) { action in
                            })
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        guard let yyyymm = textField.text else {
                            return
                        }
                        
                        
                        let test_worksheet = WorkSheetManager.sharedManager.createWorkSheet(yyyymm)
                        
                        //TODO: 生成されたmodelをjson形式で保存
                        if let testWorkSheet = test_worksheet {
                            self.worksheetManager.saveLocalWorkSheet(yyyymm, workSheet: testWorkSheet)
                        }
                        self.insertWorkSheetAferloadLoaclWorkSheet()
                        
                    }
                }
            }
        })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GoDetailWorkSheetSegue" {
            if let destination = segue.destination as? DaySheetViewController {
                if let selectedWorkSheet = selectedWorkSheet {
                    if let yearMonth = selectedWorkSheet.workdate?.yearMonthKey() {
                        destination.yearMonth = yearMonth
                    }
                    destination.groups = groups
                }
            }
        }
    }
 

    // MARK: Internal Methods
    
    
    // MARK: Private Methods
    private func initControls() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SheetViewController.addSheetButtonTouched(_ :)))
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    private func emptyMessage(_ on: Bool) {
        messageLabel?.isHidden = !on
        sheetTableView?.backgroundView = on ? messageLabel : nil;
        sheetTableView?.separatorStyle = on ? .none : .singleLine;
    }
    
    private func insertWorkSheetAferloadLoaclWorkSheet() {
        workSheets.removeAll()
        worksheetManager.loadLocalWorkSheets()
        let workSheetDict = worksheetManager.worksheetDict
        for dictValue in workSheetDict.values {
            if let dictValue = dictValue as? [String: Any] {
                let workSheet = WorkSheet(dict: dictValue)
                workSheets.append(workSheet)
            }
        }
        workSheets.sort { firstWorkSheet, secondWorkSheet -> Bool in
            guard let firstWorkSheet = firstWorkSheet.workdate?.MonthInt() else {
                return false
            }
            guard let secondWorkSheet = secondWorkSheet.workdate?.MonthInt() else {
                return false
            }
            return firstWorkSheet < secondWorkSheet
        }
        sheetTableView?.reloadData()
    }
    
    private func deleteWorkSheetAlert(completion: @escaping (Bool) -> ()) {
        let deleteWorkSheetAC = UIAlertController(title: "勤務表削除", message: "本当に勤務表を削除しますか？", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "削除", style: .default) { action in
            completion(true)
            print("tapped WorkSheet delete Button")
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            completion(false)
            print("tapped WorkSheet cancel Button")
        }
        
        deleteWorkSheetAC.addAction(deleteButton)
        deleteWorkSheetAC.addAction(cancelButton)
        present(deleteWorkSheetAC, animated: true, completion: nil)
    }
    
}


// MARK: Extensions
extension SheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedWorkSheet = workSheets[indexPath.row]
        self.performSegue(withIdentifier: "GoDetailWorkSheetSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //TODO: 勤務表削除アラート
            self.deleteWorkSheetAlert { check in
                if check == true {
                    
                    //TODO: delete worksheet in jsonfile
                    let selectedWorkSheet = self.workSheets[indexPath.row]
                    
                    if let key = selectedWorkSheet.workdate?.yearMonthKey() {
                        self.worksheetManager.removeLocalWorkSheet(yearMonth: key)
                        self.workSheets.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.insertWorkSheetAferloadLoaclWorkSheet()
                    }
                } else {
                    tableView.setEditing(false, animated: true)
                }
            }
        }
        
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
}

extension SheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        emptyMessage(workSheets.count == 0)
        
        return workSheets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetCell") as! WorkSheetCell
        
        let workSheet = workSheets[indexPath.row]
        cell.settingCell(workSheet)
        
        return cell
    }

}


