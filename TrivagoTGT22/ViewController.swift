import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    lazy var trivagoNode: SCNNode = {
        let scene = SCNScene(named: "art.scnassets/trivago_logo.scn")!
        let node = SCNNode()
        scene.rootNode.childNodes.forEach { node.addChildNode($0) }
        sceneView.scene.rootNode.addChildNode(node)
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions = [.showFeaturePoints]
        
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard let result = sceneView.hitTest(location).first else { return }
        trivagoNode.worldPosition = SCNVector3(
            result.worldCoordinates.x,
            result.worldCoordinates.y,
            result.worldCoordinates.z
        )
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

}
