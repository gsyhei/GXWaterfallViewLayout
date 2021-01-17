//
//  GXWaterfallViewLayout.swift
//  GXWaterfallViewLayoutSmaple
//
//  Created by Gin on 2021/1/16.
//

import UIKit

@objc public protocol GXWaterfallViewLayoutDelegate: NSObjectProtocol {
    func size(layout: GXWaterfallViewLayout, indexPath: IndexPath, itemSize: CGFloat) -> CGFloat
    @objc optional func moveItem(at sourceIndexPaths:[IndexPath], toIndexPaths:[IndexPath])
}

public class GXWaterfallViewLayout: UICollectionViewLayout {
    public var numberOfColumns: Int = 3
    public var lineSpacing: CGFloat = 0
    public var interitemSpacing: CGFloat = 0
    public var headerSize: CGFloat = 0
    public var footerSize: CGFloat = 0
    public var sectionInset: UIEdgeInsets = .zero
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    public weak var delegate: GXWaterfallViewLayoutDelegate?
    public var shouldAnimations: Array<IndexPath> = []
    
    private var cellLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var headLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var footLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var maxScrollDirPositionForColumn: Dictionary<Int, CGFloat> = [:]
    private var startScrollDirPosition: CGFloat = 0
}

public extension GXWaterfallViewLayout {
    
    override func prepare() {
        super.prepare()
        
        self.cellLayoutInfo.removeAll()
        self.headLayoutInfo.removeAll()
        self.footLayoutInfo.removeAll()
        self.maxScrollDirPositionForColumn.removeAll()
        
        switch self.scrollDirection {
        case .vertical:
            self.prepareLayoutAtScrollDirectionVertical()
        case .horizontal:
            self.prepareLayoutAtScrollDirectionHorizontal()
        @unknown default:
            fatalError("unknown scrollDirection.")
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes: Array<UICollectionViewLayoutAttributes> = Array()
        for attributes in self.cellLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        for attributes in self.headLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        for attributes in self.footLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cellLayoutInfo[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return self.headLayoutInfo[indexPath]
        }
        else if elementKind == UICollectionView.elementKindSectionFooter {
            return self.footLayoutInfo[indexPath]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        switch self.scrollDirection {
        case .vertical:
            return CGSize(width: max(self.startScrollDirPosition, self.collectionView!.frame.width), height: self.collectionView!.frame.height)
        case .horizontal:
            return CGSize(width: self.collectionView!.frame.width, height: max(self.startScrollDirPosition, self.collectionView!.frame.height))
        @unknown default:
            fatalError("unknown scrollDirection.")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if self.collectionView!.bounds.size.equalTo(newBounds.size) {
            return true
        }
        return false
    }
    
    /** 这部分updateAction的代码只作为参考，可以继承重写来做效果
    override func finalizeCollectionViewUpdates() {
        self.shouldAnimations.removeAll()
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        var indexPaths: Array<IndexPath> = []
        for item in updateItems {
            switch item.updateAction {
            case .insert:
                if item.indexPathAfterUpdate != nil {
                    indexPaths.append(item.indexPathAfterUpdate!)
                }
            case .delete:
                if item.indexPathBeforeUpdate != nil {
                    indexPaths.append(item.indexPathBeforeUpdate!)
                }
            case .move, .reload:
                if item.indexPathBeforeUpdate != nil {
                    indexPaths.append(item.indexPathBeforeUpdate!)
                }
                if item.indexPathAfterUpdate != nil {
                    indexPaths.append(item.indexPathAfterUpdate!)
                }
            default: break
            }
        }
        self.shouldAnimations.append(contentsOf: indexPaths)
    }

    // 对应UICollectionViewUpdateItem 的indexPathBeforeUpdate 设置调用
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        guard attributes != nil else { return nil }
        if self.shouldAnimations.contains(itemIndexPath) {
            attributes?.center = CGPoint(x: self.collectionView!.bounds.midX, y: self.collectionView!.bounds.midY)
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes?.alpha = 0.1
            self.shouldAnimations.removeAll { (indexPath) -> Bool in
                return itemIndexPath == indexPath
            }
        }
        return attributes
    }
    
    // 对应UICollectionViewUpdateItem 的indexPathAfterUpdate 设置调用
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        guard attributes != nil else { return nil }
        if self.shouldAnimations.contains(itemIndexPath) {
            attributes?.center = CGPoint(x: self.collectionView!.bounds.midX, y: self.collectionView!.bounds.midY)
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes?.alpha = 0.1
            self.shouldAnimations.removeAll { (indexPath) -> Bool in
                return itemIndexPath == indexPath
            }
        }
        return attributes
    }
    
    override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        if self.delegate != nil {
            if self.delegate!.responds(to: #selector(self.delegate!.moveItem(at:toIndexPaths:))) {
                self.delegate?.moveItem?(at: previousIndexPaths, toIndexPaths: targetIndexPaths)
            }
        }
        return context
    }
    */
}

fileprivate extension GXWaterfallViewLayout {
    
    func prepareLayoutAtScrollDirectionVertical() {
        guard self.collectionView?.dataSource != nil else { return }
        
        // CollectionView content width
        let contentWidth: CGFloat = self.collectionView!.frame.width - self.collectionView!.contentInset.left - self.collectionView!.contentInset.right
        // Section content width
        let sectionContentWidth: CGFloat = contentWidth - self.sectionInset.left - self.sectionInset.right
        // cell width
        let itemWidth: CGFloat = floor((sectionContentWidth - self.interitemSpacing*CGFloat(self.numberOfColumns - 1))/CGFloat(self.numberOfColumns))
        // Start point y
        self.startScrollDirPosition = 0.0
        
        // Section attributes
        let sectionCount: Int = self.collectionView!.numberOfSections
        let respondsSupplementary: Bool = self.collectionView!.dataSource!.responds(to: #selector(self.collectionView!.supplementaryView(forElementKind:at:)))
        
        for section in 0..<sectionCount {
            // Haders layout
            if self.headerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                attributes.frame = CGRect(x: self.collectionView!.contentInset.left, y: self.startScrollDirPosition, width: contentWidth, height: self.headerSize)
                self.headLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.headerSize + self.sectionInset.top
            }
            else {
                self.startScrollDirPosition += self.sectionInset.top
            }
            
            // Set first section cells point y
            for row in 0..<self.numberOfColumns {
                self.maxScrollDirPositionForColumn[row] = self.startScrollDirPosition
            }
            
            // Cells layout
            let rowCount: Int = self.collectionView!.numberOfItems(inSection: section)
            for row in 0..<rowCount {
                let indexPath = IndexPath(row: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // 计算出当前的cell加到哪一列（瀑布流是加载到最短的一列）
                var top: CGFloat = self.maxScrollDirPositionForColumn[0]!
                var currentRow: Int = 0
                for i in 1..<self.numberOfColumns {
                    let iTop: CGFloat = self.maxScrollDirPositionForColumn[i]!
                    if iTop < top {
                        top = iTop; currentRow = i
                    }
                }
                let left = self.collectionView!.contentInset.left + self.sectionInset.left + (self.interitemSpacing + itemWidth) * CGFloat(currentRow)
                let itemHeight: CGFloat = self.delegate?.size(layout: self, indexPath: indexPath, itemSize: itemWidth) ?? 0
                attributes.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
                self.cellLayoutInfo[indexPath] = attributes
                // 重新设置当前列的Y值（也就是当前列cell到下个cell的值）
                top += self.lineSpacing + itemHeight
                self.maxScrollDirPositionForColumn[currentRow] = top
                //当是section的最后一个cell，取出最后一列cell的底部X值，设置startScrollDirPosition(最长X的列)决定下个视图对象的起始X值
                if row == (rowCount - 1) {
                    var maxTop: CGFloat = self.maxScrollDirPositionForColumn[0]!
                    for i in 1..<self.numberOfColumns {
                        let iTop: CGFloat = self.maxScrollDirPositionForColumn[i]!
                        if iTop > maxTop {
                            maxTop = iTop
                        }
                    }
                    // 由于是cell到下个cell的Y值，所以如果没有下一个cell就需要减去cell间距
                    self.startScrollDirPosition = maxTop - self.lineSpacing + self.sectionInset.bottom
                }
            }
            
            // Footers layout
            if self.footerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                attributes.frame = CGRect(x: self.collectionView!.contentInset.left, y: self.startScrollDirPosition, width: contentWidth, height: self.footerSize)
                self.footLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.footerSize
            }
        }
    }
    
    func prepareLayoutAtScrollDirectionHorizontal() {
        guard self.collectionView?.dataSource != nil else { return }
        
        // CollectionView content height
        let contentHeight: CGFloat = self.collectionView!.frame.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        // Section content height
        let sectionContentHeight: CGFloat = contentHeight - self.sectionInset.top - self.sectionInset.bottom
        // cell height
        let itemHeight: CGFloat = floor((sectionContentHeight - self.lineSpacing*CGFloat(self.numberOfColumns - 1))/CGFloat(self.numberOfColumns))
        // Start point x
        self.startScrollDirPosition = 0.0
        
        // Section attributes
        let sectionCount: Int = self.collectionView!.numberOfSections
        let respondsSupplementary: Bool = self.collectionView!.dataSource!.responds(to: #selector(self.collectionView!.supplementaryView(forElementKind:at:)))
        
        for section in 0..<sectionCount {
            // Haders layout
            if self.headerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                attributes.frame = CGRect(x: self.startScrollDirPosition, y: self.collectionView!.contentInset.top, width: self.headerSize, height: contentHeight)
                self.headLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.headerSize + self.sectionInset.left
            }
            else {
                self.startScrollDirPosition += self.sectionInset.left
            }
            
            // Set first section cells point x
            for row in 0..<self.numberOfColumns {
                self.maxScrollDirPositionForColumn[row] = self.startScrollDirPosition
            }
            
            // Cells layout
            let rowCount: Int = self.collectionView!.numberOfItems(inSection: section)
            for row in 0..<rowCount {
                let indexPath = IndexPath(row: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // 计算出当前的cell加到哪一列（瀑布流是加载到最短的一列）
                var left: CGFloat = self.maxScrollDirPositionForColumn[0]!
                var currentRow: Int = 0
                for i in 1..<self.numberOfColumns {
                    let iLeft: CGFloat = self.maxScrollDirPositionForColumn[i]!
                    if iLeft < left {
                        left = iLeft; currentRow = i
                    }
                }
                let top = self.collectionView!.contentInset.top + self.sectionInset.top + (self.lineSpacing + itemHeight) * CGFloat(currentRow)
                let itemWidth: CGFloat = self.delegate?.size(layout: self, indexPath: indexPath, itemSize: itemHeight) ?? 0
                attributes.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
                self.cellLayoutInfo[indexPath] = attributes
                // 重新设置当前列的x值（也就是当前列cell到下个cell的值）
                left += self.interitemSpacing + itemWidth
                self.maxScrollDirPositionForColumn[currentRow] = left
                //当是section的最后一个cell，取出最后一列cell的底部X值，设置startScrollDirPosition(最长Y的列)决定下个视图对象的起始Y值
                if row == (rowCount - 1) {
                    var maxLeft: CGFloat = self.maxScrollDirPositionForColumn[0]!
                    for i in 1..<self.numberOfColumns {
                        let iLeft: CGFloat = self.maxScrollDirPositionForColumn[i]!
                        if iLeft > maxLeft {
                            maxLeft = iLeft
                        }
                    }
                    // 由于是cell到下个cell的X值，所以如果没有下一个cell就需要减去cell间距
                    self.startScrollDirPosition = maxLeft - self.interitemSpacing + self.sectionInset.right
                }
            }
            
            // Footers layout
            if self.footerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                attributes.frame = CGRect(x: self.startScrollDirPosition, y: self.collectionView!.contentInset.top, width: self.footerSize, height: contentHeight)
                self.footLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.footerSize
            }
        }
    }
    
}
