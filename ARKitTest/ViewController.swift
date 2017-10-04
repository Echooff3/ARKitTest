//
//  ViewController.swift
//  ARKitTest
//
//  Created by John.Skibickiiii on 9/23/17.
//  Copyright © 2017 John.Skibickiiii. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var lblCount: UILabel!
    var bombSoundEffect: AVAudioPlayer?
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        
        let path = Bundle.main.path(forResource: "sheep.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
        } catch {
            // couldn't load file :(
        }
        self.view.addSubview(self.lblCount)
    }
    
    @objc
    func handleTap(gestureRecognize: UITapGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        let sheep = SCNScene(named:"sheep.dae")
        let sheepNode = sheep?.rootNode.childNode(withName: "Sheep", recursively: true)!
        sceneView.scene.rootNode.addChildNode(sheepNode!)
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -2.0
        translation.columns.3.y = -0.25
        sheepNode?.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        sheepNode?.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        count += 1
        let msg = String(format:"Sheep Count: %d", count)
        self.lblCount.text = msg
        do {
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
