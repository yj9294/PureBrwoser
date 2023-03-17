//
//  TabVC.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/7.
//

import UIKit

class TabVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TabVC {
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func newAction() {
        BrowserUtil.shared.add()
        self.dismiss(animated: true)
        
        FirebaseUtil.log(event: .tabNew, params: ["lig": "tab"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseUtil.log(event: .tabShow)
    }
}

extension TabVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BrowserUtil.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            let item = BrowserUtil.shared.items[indexPath.row]
            cell.item = item
            cell.deleteHandle = { [weak collectionView] in
                BrowserUtil.shared.remove(item)
                collectionView?.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserUtil.shared.items[indexPath.row]
        BrowserUtil.shared.select(item)
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = ((view.window?.bounds.width ?? 375.0) - 16 * 3) / 2.0
        return CGSize(width: width, height: 204)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    
}

class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var deleteHandle: (()->Void)? = nil
    
    var item: BrowserItem? = nil {
        didSet {
            titleLabel.text = item?.webView.url?.absoluteString
            deleteButton.isHidden = BrowserUtil.shared.count == 1
            borderWidth = item == BrowserUtil.shared.item ? 2.0 : 0.5
        }
    }
    
    @IBAction func deleteAction() {
        deleteHandle?()
    }
}
