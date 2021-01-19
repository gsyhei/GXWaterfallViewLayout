//
//  ViewController.swift
//  GXWaterfallViewLayoutSmaple
//
//  Created by Gin on 2021/1/16.
//

import UIKit

let GX_ITEM_TITLE: Array = ["瀑布流UICollectionView_纵向","瀑布流UICollectionView_横向"]

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GX_UIKitSample"
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GX_ITEM_TITLE.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = GX_ITEM_TITLE[indexPath.row]
        
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctr: GXWaterViewController = GXWaterViewController()
        ctr.title = GX_ITEM_TITLE[indexPath.row]
        if indexPath.row == 0 {
            ctr.scrollDirection = .vertical
        }
        else {
            ctr.scrollDirection = .horizontal
        }
        self.navigationController?.pushViewController(ctr, animated: true)
    }
}

