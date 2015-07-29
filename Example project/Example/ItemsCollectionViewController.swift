//
//  ItemsCollectionViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 7/5/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

let identifier = "cell"

class ItemsCollectionViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: ItemsCollectionViewController.collectionViewLayout())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func collectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.mainScreen().bounds.width - 1 - 1)
        collectionViewLayout.itemSize = CGSize(width: width, height: 200)
        collectionViewLayout.minimumInteritemSpacing = 1
        collectionViewLayout.minimumLineSpacing = 1

        return collectionViewLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.backgroundColor = UIColor(hex: 0xeeeeee)

        collectionView!.contentInset = UIEdgeInsets(top: 104, left: 0, bottom: 0, right: 0)
        collectionView!.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ItemCell

        cell.backgroundColor = UIColor.whiteColor()

        return cell
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}