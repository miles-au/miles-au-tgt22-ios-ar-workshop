import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    var activeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(onRotate))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onPinch))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        guard let position = rayCast(at: location) else { return }
        
        activeNode?.worldPosition = position
    }
    
    @objc func onRotate(_ gesture: UIRotationGestureRecognizer) {
        guard activeNode?.parent != nil else { return }
        
        let rotation = -gesture.rotation / 10
        
        if gesture.state == .changed {
            let rotationQuarternion = SCNQuaternion(0.0, sin(rotation/2), 0.0, cos(rotation/2))
            activeNode?.localRotate(by: rotationQuarternion)
        }
    }
    
    @objc func onPinch(_ gesture: UIPinchGestureRecognizer) {
        guard activeNode?.parent != nil else { return }
        
        let velocity = Float((gesture.scale - 1) / 10 + 1)
        
        if gesture.state == .changed,
           let node = activeNode {
            let scale = node.scale
            node.scale = SCNVector3(scale.x * velocity, scale.y * velocity, scale.z * velocity)
        }
    }
    
    func rayCast(at point: CGPoint) -> SCNVector3? {
        if let query = sceneView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .horizontal),
           let collision = sceneView.session.raycast(query).first {
            let transformColumn3 = collision.worldTransform.columns.3
            let worldPosition = SCNVector3(
                transformColumn3.x,
                transformColumn3.y,
                transformColumn3.z
            )
            return worldPosition
        }
        return nil
    }

    @IBAction func addModelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToModelSelectionViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToModelSelectionViewController" {
            if let modelSelectionViewController = segue.destination as? ModelSelectionViewController {
                modelSelectionViewController.delegate = self
            }
        }
    }
}

extension ARViewController: ModelSelectionViewControllerDelegate {
    func didSelect(model: TRVModel) {
        let node = SCNNode()
        model.scene.rootNode.childNodes.forEach { node.addChildNode($0) }
        sceneView.scene.rootNode.addChildNode(node)
        activeNode = node
    }
}
