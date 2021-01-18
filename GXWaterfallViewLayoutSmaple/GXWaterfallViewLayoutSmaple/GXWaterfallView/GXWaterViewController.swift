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
        layout.interitemSpacing = 10.0;
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = self.scrollDirection
        self.waterLayout.headerSize = 40.0
        self.waterLayout.footerSize = 40.0
        if (layout.scrollDirection == .vertical) {
            self.waterLayout.numberOfColumns = 4;
        } else {
            self.waterLayout.numberOfColumns = 5;
        }
//        layout.delegate = self
        return layout
    }()
    
    private lazy var waterCollectionView: UICollectionView = {
        let top = 44.0 + UIApplication.shared.statusBarFrame.height
        let frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: self.view.frame.height - top)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.waterLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.white
//        self.waterCollectionView.delegate = self;
//        self.waterCollectionView.dataSource = self;
        return collectionView
    }()
    
    private lazy var imageList: Array<Array<String>> = {
        var imageArr: Array<Array<String>> = []
        var array1: Array<String> = []
        var array2: Array<String> = []
        for i in 0..<100 {
            array1.append(String(format: "%d.jpeg", i%13))
        }
        imageArr.append(array1)
        imageArr.append(array2)
        
        return imageArr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "瀑布流"
        self.view.addSubview(self.waterCollectionView)
        
        self.waterCollectionView.register(UINib(nibName: NSStringFromClass(GXWaterCVCell.classForCoder()), bundle: nil), forCellWithReuseIdentifier: GXSectionCellID)
        self.waterCollectionView.register(UINib(nibName: NSStringFromClass(GXHeaderCRView.classForCoder()), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GXSectionHeaderID)
        self.waterCollectionView.register(UINib(nibName: NSStringFromClass(GXFooterCRView.classForCoder()), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GXSectionFooterID)
        
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

//extension GXWaterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
//    //设置head foot视图
//    - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//            GXHeaderCRView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GXSectionHeaderID forIndexPath:indexPath];
//            return head;
//        }
//        else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//            GXFooterCRView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GXSectionFooterID forIndexPath:indexPath];
//            return foot;
//        }
//        return nil;
//    }
//
//    - (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
//    {
//        cell.contentView.alpha = 0.2;
//        cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), 0);
//
//        [UIView animateKeyframesWithDuration:.5 delay:0.0 options:0 animations:^{
//            /** 分步动画   第一个参数是该动画开始的百分比时间  第二个参数是该动画持续的百分比时间 */
//            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
//                cell.contentView.alpha = 0.5;
//                cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.1, 1.1), 0);
//            }];
//            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
//                cell.contentView.alpha = 1.0;
//                cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, 1.0), 0);
//            }];
//        } completion:^(BOOL finished) {}];
//    }
//
//    - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//        return self.imageArr.count;
//    }
//
//    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//        return [self.imageArr[section] count];
//    }
//
//    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//        GXWaterCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GXSectionCellID forIndexPath:indexPath];
//        cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
//        cell.textTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
//
//        return cell;
//    }
//
//    - (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
//        return YES;
//    }
//
//    - (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
//    }
//
//    - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//        NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
//    }
    
//}



//#pragma mark - GXWaterCollectionViewLayoutDelegate
//
//- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
//    return [UIImage imageNamed:[self.imageArr[indexPath.section] objectAtIndex:indexPath.row]];
//}
//
//- (CGFloat)sizeWithLayout:(GXWaterCollectionViewLayout*)layout indexPath:(NSIndexPath*)indexPath itemSize:(CGFloat)itemSize {
//    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
//        return [self imageAtIndexPath:indexPath].size.height / [self imageAtIndexPath:indexPath].size.width * itemSize;
//    } else {
//        return [self imageAtIndexPath:indexPath].size.width / [self imageAtIndexPath:indexPath].size.height * itemSize;
//    }
//}
//
//- (void)moveItemAtSourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
//    if(sourceIndexPath.row != destinationIndexPath.row) {
//        NSString *value = self.imageArr[sourceIndexPath.section][sourceIndexPath.row];
//        [self.imageArr[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
//        [self.imageArr[destinationIndexPath.section] insertObject:value atIndex:destinationIndexPath.row];
//        NSLog(@"from:%@  to:%@", sourceIndexPath, destinationIndexPath);
//    }
//}
