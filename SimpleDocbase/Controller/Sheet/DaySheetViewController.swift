//
//  DaySheetViewController.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/11.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

final class DaySheetViewController : UIViewController {
    
    // MARK: Properties
    var workDate: Date?
    var sheetItems = [WorkSheetItem]()
    
    // MARK: IBOutlet
    @IBOutlet var daySheetTableView: UITableView!
    @IBOutlet var daySheetHeaderView: DaySheetHeaderView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let yearmonth = workDate?.yearMonthString() {
            self.title = yearmonth + "_勤務表"
        }
        
    }
    
    // MARK: Action
    @objc func uploadButtonTouched(_ sender: UIBarButtonItem) {
        //入力された勤務表をDocbaseへアップロード
        let uploadAlertVC = UIAlertController(title: "アップロード", message: "勤務表をDocbaseへ登録しますか。", preferredStyle: .alert)
        uploadAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            //TODO: メモ投稿処理
            print("post memo!")
        }))
        uploadAlertVC.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler:nil))
        present(uploadAlertVC, animated: true, completion: nil)
    }
    
    // MARK: Private
    private func initControls() {
        
        let uploadBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                              target: self,
                                              action: #selector(DaySheetViewController.uploadButtonTouched(_ :)))
        
        navigationItem.rightBarButtonItems = [uploadBarButton]
    }
    
    
}


// MARK: Extensions
extension DaySheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editVC = DaySheetEditViewController()
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return daySheetHeaderView;
    }
}

extension DaySheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sheetItems.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetItemCell") as! WorkSheetItemCell
        
        let sheetItem = sheetItems[indexPath.row]
        cell.settingCell(sheetItem)
        
        return cell
    }
    
}
