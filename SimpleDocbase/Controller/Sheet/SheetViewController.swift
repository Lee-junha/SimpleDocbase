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
        loadTestData()
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler:{
                                        (action:UIAlertAction!) -> Void in
                                        print("OK")
                                        
                                        let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                                        if textFields != nil {
                                            for textField:UITextField in textFields! {
                                                
                                                //TODO: 6桁数字なのかをチェック
                                                
                                                
                                                //let test_worksheet = WorkSheetManager.sharedManager.createWorkSheet("201711")
                                                
                                                guard let yyyymm = textField.text else {
                                                    return
                                                }
                                                let test_worksheet = WorkSheetManager.sharedManager.createWorkSheet(yyyymm)
                                                
                                                //TODO: 生成されたmodelをjson形式で保存
                                            }
                                        }
                                        
        }))
        
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
                    destination.workDate = selectedWorkSheet.workdate
                    destination.sheetItems = selectedWorkSheet.items
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
    
    private func loadTestData() {
        for i in 0..<10 {
            guard let year_month = Date.createDate(year: 2017, month: i+1) else {
                continue
            }
            var work_sheet = WorkSheet(date:year_month)
            work_sheet.workDaySum = 10 + Int(arc4random()%10)
            work_sheet.workTimeSum = Double(120) + Double(arc4random()%20)
            for j in 0..<31 {
                let work_sheet_item = WorkSheetItem(year: 2017, month:i, day:j)
                work_sheet.items?.append(work_sheet_item)
            }
            workSheets.append(work_sheet)
        }
    }
    
    private func emptyMessage(_ on: Bool) {
        messageLabel?.isHidden = !on
        sheetTableView?.backgroundView = on ? messageLabel : nil;
        sheetTableView?.separatorStyle = on ? .none : .singleLine;
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
            self.workSheets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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


