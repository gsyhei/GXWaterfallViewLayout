//
//  GXWaterViewController.swift
//  GXWaterfallViewLayoutSmaple
//
//  Created by Gin on 2021/1/19.
//

import UIKit

let GXSectionHeaderID = "GXSectionHeaderID"
let GXSectionFooterID = "GXSectionFooterID"
let GXSectionCellID   = "GXSectionCellID"

class GXWaterViewController: UIViewController {
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    private lazy var waterLayout: GXWaterfallViewLayout = {
        let layout = GXWaterfallViewLayout()
        layout.lineSpacing = 10.0
        layout.interitemSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = self.scrollDirection
        layout.headerSize = 40.0
        layout.footerSize = 40.0
        if (layout.scrollDirection == .vertical) {
            layout.numberOfColumns = 4
        } else {
            layout.numberOfColumns = 5
        }
        layout.delegate = self
        
        return layout
    }()
    
    private lazy var waterCollectionView: UICollectionView = {
        let top = 44.0 + UIApplication.shared.statusBarFrame.height
        let frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: self.view.frame.height - top)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.waterLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var imageList: Array<Array<String>> = {
        var imageArr: Array<Array<String>> = []
        var array1: Array<String> = []
        var array2: Array<String> = []
        for i in 0..<100 {
            array1.append(String(format: "%d.jpeg", i%13))
            array2.append(String(format: "%d.jpeg", i%13))
        }
        imageArr.append(array1)
        imageArr.append(array2)
        
        return imageArr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "瀑布流"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.waterCollectionView)
        
        self.waterCollectionView.register(UINib(nibName: "GXWaterCVCell", bundle: nil), forCellWithReuseIdentifier: GXSectionCellID)
        self.waterCollectionView.register(UINib(nibName: "GXHeaderCRView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GXSectionHeaderID)
        self.waterCollectionView.register(UINib(nibName: "GXFooterCRView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GXSectionFooterID)
        
        let longGest = UILongPressGestureRecognizer(target: self, action: #selector(longGestTapped(_:)))
        self.waterCollectionView.addGestureRecognizer(longGest)
    }
    
    @objc private func longGestTapped(_ gest: UILongPressGestureRecognizer) {
        switch (gest.state) {
        case .began:
            let point = gest.location(in: gest.view)
            let touchIndexPath = self.waterCollectionView.indexPathForItem(at: point)
                if touchIndexPath != nil {
                    self.waterCollectionView.beginInteractiveMovementForItem(at: touchIndexPath!)
                }
        case .changed:
            let point = gest.location(in: gest.view)
            self.waterCollectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            self.waterCollectionView.endInteractiveMovement()
        default: break
        }
    }
}

extension GXWaterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GXWaterCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: GXSectionCellID, for: indexPath) as! GXWaterCVCell
        cell.imageView.image = UIImage(named: self.imageList[indexPath.section][indexPath.row])
        cell.textTitle.text = String(format: "%d", indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GXSectionHeaderID, for: indexPath)
            return header
        }
        else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GXSectionFooterID, for: indexPath)
            return footer
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        NSLog("sourceIndexPath:%@, destinationIndexPath:%@", sourceIndexPath.description, destinationIndexPath.description)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("didSelectItemAtIndexPath:%@", indexPath.description)
    }
}

extension GXWaterViewController: GXWaterfallViewLayoutDelegate {
    
    func imageAtIndexPath(_ indexPath: IndexPath) -> UIImage {
        return UIImage(named: self.imageList[indexPath.section][indexPath.row])!
    }
    
    func size(layout: GXWaterfallViewLayout, indexPath: IndexPath, itemSize: CGFloat) -> CGFloat {
        if layout.scrollDirection == .vertical {
            return self.imageAtIndexPath(indexPath).size.height / self.imageAtIndexPath(indexPath).size.width * itemSize
        }
        else {
            return self.imageAtIndexPath(indexPath).size.height / self.imageAtIndexPath(indexPath).size.width * itemSize
        }
    }

    func moveItem(at sourceIndexPath: IndexPath, toIndexPath: IndexPath) {
        NSLog("from:%@  to:%@", sourceIndexPath.description, toIndexPath.description);
        let value: String = self.imageList[sourceIndexPath.section][sourceIndexPath.row]
        self.imageList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        self.imageList[toIndexPath.section].insert(value, at: toIndexPath.row)
    }
}
