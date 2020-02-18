//
//  InkSettingsToolsCell.swift
//  PDFReadIt
//
//  Created by Dmitry Zawadsky on 17.02.2020.
//  Copyright © 2020 Kishikawa Katsumi. All rights reserved.
//

import UIKit

protocol InkSettingsToolsCellDelegate: AnyObject {
    func didSelect(tool: InkSettings.DrawingTool)
}

class InkSettingsToolsCell: UITableViewCell {

    static let cellHeight: CGFloat = 80

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Constants
    let minimumInteritemSpacing: CGFloat = 8
    let minimumLineSpacing: CGFloat = 8

    // MARK: - Variables
    weak var delegate: InkSettingsToolsCellDelegate?
    var tools = [InkSettings.DrawingTool]()

    // MARK: - Lifecycle
    func configure(with settings: InkSettings) {
        tools = InkSettings.DrawingTool.allCases
        let name = String(describing: InkSettingsToolCollectionCell.self)
        collectionViewHeightConstraint.constant = Self.cellHeight
        collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension InkSettingsToolsCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(tool: tools[indexPath.row])
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset = minimumInteritemSpacing / 2 - minimumLineSpacing / 2
        let sizeToReturn = CGSize(width: collectionView.frame.size.width / CGFloat(tools.count) - offset,
                                  height: InkSettingsToolsCell.cellHeight)
        return sizeToReturn
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
}

extension InkSettingsToolsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = String(describing: InkSettingsToolCollectionCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                            for: indexPath) as? InkSettingsToolCollectionCell else {
                                                                fatalError("Unable to dequeue InkSettingsToolCollectionCell")
        }
        cell.configure(tools[indexPath.row])
        return cell
    }
}
