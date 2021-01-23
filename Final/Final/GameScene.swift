//
//  GameScene.swift
//  Final
//
//  Created by njuios on 2021/1/9.
//

import SpriteKit
import GameplayKit
import CoreML
import Vision

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    var time = Timer()
    //drawkit timer
    var time1 = Timer()
    //cheat timer
    var gamenodes = [SKNode]()
    //save sknodes in gamescene
    var startnodes = [SKNode]()
    //save sknodes in startscene
    var clearnodes = [SKNode]()
    //save sknodes in clearscene
    var helpnodes = [SKNode]()
    //save sknodes in helpscene
    var funcnodes = [SKSpriteNode]()
    //save function buttons(rotate/translate...)
    var drawnodes = [SKNode:[CGPoint]]()
    //save every node with its parameter
    var selectedNodes:[UITouch : SKNode] = [:]
    //save all touches
    var gametimetext = SKLabelNode()
    var canvasnode = SKShapeNode()
    var cheatnode = SKSpriteNode()
    var nowcvnode:SKNode? = nil
    var tempcheatline:SKShapeNode? = nil
    var cheatlinepoints = [CGPoint]()
    lazy var classificationRequest: VNCoreMLRequest = {
        // Load the ML model through its generated class and create a Vision request for it.
        //        print(Detector().model)
        guard let model = try? VNCoreMLModel(for: Detector().model) else {
            fatalError("miss error when load model")
        }
        let request = VNCoreMLRequest(model: model, completionHandler: checkValue)
        request.imageCropAndScaleOption = .scaleFill
        
        return request
    }()
    var alltotalscore:Double = 0
    var stagescore:Double = 0
    var drawindex = 0
    var cheatable:Bool = false
    //control cheat button
    {
        didSet{
            if cheatable == true{
                cheatnode.texture = SKTexture(imageNamed: texture.but_cheat.imagename)
            }
            else{
                cheatnode.texture = SKTexture(imageNamed: texture.but_discheat.imagename)
            }
        }
    }
    var nowstage:Int = 1
    {
        didSet{
            if nowstage > GameKitPara.stagenum{
                nowstage = 1
            }
        }
    }
    var gamestate:Int = 0
    {
        didSet{
            if oldValue == State.start.value{
                ExitStartScene()
                if gamestate == State.help.value{
                    //click help
                    EnterHelpScene()
                }
                else if gamestate == State.game.value{
                    //click start
                    initGameValue()
                    EnterGameScene()
                }
            }
            else if oldValue == State.game.value{
                if gamestate != State.game.value{
                    /*whenever a state leavs gamestate,
                      it needs to exit adjust mode
                      except:game->game in special case(about cheatmode)*/
                    ExitAdjustMode()
                }
                if gamestate == State.start.value{
                    //click back
                    ExitGameScene()
                    EnterStartScene()
                }
                else if gamestate == State.clear.value{
                    //click submit
                    ExitGameScene()
                    let image = imageFromCanvas()
                    getSubmitValue(image: image)
                }
                else if gamestate == State.cheat.value{
                    //click cheat button
                    EnterCheatScene()
                }
            }
            else if oldValue == State.cheat.value{
                if gamestate == State.game.value{
                    /*cheatmode -> gamemode
                      finish cheatline/after 3 secs
                      use points create cheat line
                      set initial state,add it to scene and enter adjust mode
                    */
                    let newcheat = createSKLine(points: cheatlinepoints)
                    createEnd(cvnode: newcheat, linewidth: GameKitPara.canvasKitWidth, points: cheatlinepoints, kind: KitName.cv_cheat.name, mode: 1)
                    newcheat.zPosition = 1
                    if tempcheatline != nil{
                        tempcheatline!.removeFromParent()
                    }
                    self.addChild(newcheat)
                    EnterAdjustMode(cvnode: newcheat)
                    ExitCheatScene()
                }
            }
            else if oldValue == State.help.value{
                //click back
                ExitHelpScene()
                if gamestate == State.start.value{
                    EnterStartScene()
                }
            }
            else if oldValue == State.clear.value{
                ExitClearScene()
                if gamestate == State.start.value{
                    //click back
                    EnterStartScene()
                }
                else if gamestate == State.game.value{
                    //next stage
                    nowstage += 1
                    EnterGameScene()
                }
            }
        }
    }
    var timecountdown:Int = GameKitPara.initTime
    {
        didSet{
            gametimetext.text = "\(timecountdown)"
        }
    }
    override func didMove(to view: SKView) {
        initGameNodes()
        initClearNodes()
        initStartNodes()
        initHelpNodes()
        EnterGame()
        nowcvnode = nil
    }
    

    func activeDrawKits(){
        time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            /*
             every 1 sec:
             randomly create a kit(skspritenode)
             add skaction to the kit(1.move from left to right 2.remove from scene)
             if the kit is special star,speed is faster
             */
            if self.timecountdown >= 0{
                self.timecountdown = self.timecountdown - 1
            }
 //           let ran = Int.random(in:0..<dk2cvKitNameDic.keys.count)
            let kitname = dk2cvKitNameDic.keys.randomElement()
            let tex = SKTexture(imageNamed: kitname!)
            let newdrawkit = SKSpriteNode(texture:tex)
            newdrawkit.scale(to: CGSize(width: GameKitPara.drawkitwid, height: GameKitPara.drawkitwid))
            newdrawkit.anchorPoint = CGPoint(x: 0, y: 0)
            newdrawkit.position = CGPoint(x:0,y:0)
            newdrawkit.name = kitname
            if kitname == KitName.dk_star.name{
                newdrawkit.run(.sequence([
                    .moveTo(x: CGFloat(GameKitPara.drawkidend-100), duration: GameKitPara.stardura),
                    .removeFromParent()
                ]))
            }
            else{
                newdrawkit.run(.sequence([
                    .moveTo(x: CGFloat(GameKitPara.drawkidend-100), duration: GameKitPara.kitdura),
                    .removeFromParent()
                ]))
            }
            self.scene?.addChild(newdrawkit)
        })
    }
}
extension GameScene{
    func submit(){
        /*let image = imageFromCanvas()
        
        getSubmitValue(image: image)*/
        gamestate = State.clear.value
    }
    func getSubmitValue(image: UIImage) {
        if let cgImage = image.cgImage {
            DispatchQueue.main.async {
                let handler = VNImageRequestHandler(cgImage: cgImage)
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification: \(error)")
                }
            }
        }
    }
    func checkValue(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNCoreMLFeatureValueObservation] {
            if results.isEmpty {
               // print("nothing found")
            }
            else {
                if let confis = results[0].featureValue.multiArrayValue{
                    //print(confis)
                    stagescore = confis[drawindex].doubleValue.roundTo(places: 6)
                }
            }
            EnterClearScene()
        }
    }
    //catch screen
    func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        //use for test
        if let imageData = currentImage.jpegData(compressionQuality: persent) as NSData? {
                let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
                imageData.write(toFile: fullPath, atomically: true)
                print("fullPath=\(fullPath)")
            }
        }
    func imageWithView(view:UIView)->UIImage{
        //render view
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func imageFromCanvas()->UIImage{
        /*
        1.create a new view in canvas size
        2.create a scene,add drawnodes to the scene(need to convert position)
        3.view.present(scene)
         */
        let skview = SKView(frame: CGRect(x:0,y:0,width:GameKitPara.scwid,height:GameKitPara.canvasmaxY - GameKitPara.canvasminY))
        let sksce = SKScene(size: CGSize(width:GameKitPara.scwid,height:GameKitPara.canvasmaxY - GameKitPara.canvasminY))
/*        let newcanvascopy = canvasnode.copy()
        if let newcanvas = newcanvascopy as? SKShapeNode{
            newcanvas.position = CGPoint(x:0,y:0)
            newcanvas.fillColor = UIColor.white
            sksce.addChild(newcanvas)
        }*/
        sksce.backgroundColor = UIColor.white
        for cvnode in drawnodes.keys{
            cvnode.removeFromParent()
            cvnode.position = cvnode.convert(cvnode.position, to: canvasnode)
            sksce.addChild(cvnode)
        }
        skview.presentScene(sksce)
        return imageWithView(view: skview)
        
 /*       if let tex = self.scene!.view?.texture(from: node){
            let view = SKView(frame: CGRect(x: 0,y: 0,width: tex.size().width,height: tex.size().height))
            let sce = SKScene(size: tex.size())
            let sprite = SKSpriteNode(texture: tex)
            sprite.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
            sce.addChild(sprite)
            view.presentScene(sce)
            return imageWithView(view: view)
        }
        else
        {
            print("imagefromnode err")
            return UIImage()
        }*/
    }
    func saveimagefromscene(){
        let image = imageFromCanvas()
        saveImage(currentImage: image, persent: 10, imageName: "shi1ro.jpg")
    }
}



