import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mirror = SCNScene(named: "art.scnassets/mirror.scn")!
        let mirrorNode = mirror.rootNode.childNodes.first!
        mirrorNode.scale = SCNVector3(0.2, 0.2, 0.2)
        
        //カメラ座標系で30cm前
        let infrontCamera = SCNVector3Make(0, 0, -0.5)
        
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        
        //ワールド座標系
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        //スクリーン座標系へ
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        //スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else {
            return
        }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        //ワールド座標系
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        mirrorNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(mirrorNode)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
