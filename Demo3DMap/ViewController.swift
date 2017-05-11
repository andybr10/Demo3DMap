//
//  ViewController.swift
//  Demo3DMap
//
//  Created by ANDREIA MARQUES on 14/03/17.
//  Copyright © 2017 Finareview. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController {
    @IBOutlet var sceneView: AGSSceneView!
    //1-01 declare 2 variable objects
    var myScene = AGSScene()
    var mySurface = AGSSurface()
    var myHomeViewPoint : AGSViewpoint!
    var myBasemap : AGSBasemap!
    //2-01 declare 2 variable objects for AGSGraphic and AGSGraphicsOverlay
    var myGraphic = AGSGraphic()
    var myGraphicsOverlay = AGSGraphicsOverlay()

    override func viewDidLoad() {
        super.viewDidLoad()
        //display 3D map
        self.display3DMap()
        //display 3D symbol
        self.display3DSymbol()
        //display text symbol
        self.displayTextSymbol()
    }
    //display 3D map
    fileprivate func display3DMap () {
        //1-02 add 3D surface model
        let elevationModel = AGSArcGISTiledElevationSource(url: NSURL(string:
            "https://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer")!
            as URL)
        self.mySurface.elevationSources.insert(elevationModel, at: 0)
        //1-03 add 2 properties for myScene
        self.myScene.baseSurface = self.mySurface
        self.myScene.basemap = AGSBasemap.streets()
        //1-04 assign to sceneView scene
        self.sceneView.scene = self.myScene
        //1-05 add a view point
        let myPoint = AGSPoint(x: -122.44306, y: 37.75865, z:2000, spatialReference:
            AGSSpatialReference.wgs84())
        let myCamera = AGSCamera(location: myPoint, heading: -20, pitch: 70, roll: 0)
        self.myHomeViewPoint = AGSViewpoint(center: myPoint, scale: 50000, camera: myCamera)
        self.sceneView.setViewpoint(self.myHomeViewPoint)
   
    }
    func display3DSymbol(){
        //2-02 create a location for 3D symbol
        let myPoint = AGSPoint(x: -122.461291, y: 37.802724, z:100, spatialReference:AGSSpatialReference.wgs84())
        //2-03 create a 3D symbol
        let mySymbol = AGSSimpleMarkerSceneSymbol(style: .cone, color: .red, height: 300, width: 300, depth: 300, anchorPosition: .bottom)
        //2-04 wrap point and symbol objects to myGraphic object
        self.myGraphic = AGSGraphic(geometry: myPoint, symbol: mySymbol, attributes: nil)
        //2-05 add myGrphic to myGraphicsOverlay and set surfacePlacement property
        self.myGraphicsOverlay.graphics.add(self.myGraphic)
        self.myGraphicsOverlay.sceneProperties?.surfacePlacement =
            AGSSurfacePlacement.relative
        //2-06 add myGraphicsOverlay to sceneView graphicsOverlays array
        self.sceneView.graphicsOverlays.add(myGraphicsOverlay)
    }
    func displayTextSymbol(){
        //2-02 create a location for text symbol
        let myTextPoint = AGSPoint(x: -122.461291, y: 37.802724, z:400, spatialReference:AGSSpatialReference.wgs84())
        //2-03 add a string and create a text symbol
        let myText = "Right Place!"
        let myTextSymbol = AGSTextSymbol(text: myText, color: UIColor.blue
            , size: 18, horizontalAlignment: AGSHorizontalAlignment.center, verticalAlignment:
            AGSVerticalAlignment.bottom)
        //2-04 wrap point and symbol objects to myGraphic object
        self.myGraphic = AGSGraphic(geometry: myTextPoint, symbol: myTextSymbol,
                                    attributes: nil)
        //2-05 add myGrphic to myGraphicsOverlay and set surfacePlacement property
        self.myGraphicsOverlay.graphics.add(self.myGraphic)
        self.myGraphicsOverlay.sceneProperties?.surfacePlacement =
            AGSSurfacePlacement.relative
        //2-06 add myGraphicsOverlay to sceneView graphicsOverlays array
        self.sceneView.graphicsOverlays.add(myGraphicsOverlay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.sceneView.setViewpoint(self.myHomeViewPoint)

    }

    @IBAction func mySegmentedControlSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //Streets
            myBasemap = AGSBasemap.streets()
            break;
        case 1: //Satellite 
            myBasemap = AGSBasemap.imagery()
            break;
        case 2: //Ocean 
            myBasemap = AGSBasemap.oceans()
            break;
        case 3: //Topo
            myBasemap = AGSBasemap.topographic()
            break;
        default:
            break;
        }
         self.myScene.basemap = myBasemap
    }
}

