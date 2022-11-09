import UIKit
import SceneKit

protocol ModelSelectionViewControllerDelegate {
    func didSelect(model: TRVModel)
}

class ModelSelectionViewController: UICollectionViewController {
    
    lazy var models: [TRVModel] = {
        return TRVModel.names.compactMap { name in
            guard let scene = SCNScene(named: "art.scnassets/\(name).scn"),
            let image = UIImage(named: name)
            else {
                return nil
            }
            return TRVModel(scene: scene, image: image)
        }
    }()
    
    var delegate: ModelSelectionViewControllerDelegate?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelSelectionCell", for: indexPath) as! ModelSelectionCollectionViewCell
        
        cell.setImage(to: models[indexPath.item].image)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(model: models[indexPath.item])
        dismiss(animated: true)
    }
}

extension ModelSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset.left + collectionView.contentInset.right
        let dimension = ((collectionView.bounds.width - contentInset) / 3) - 5.0
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
