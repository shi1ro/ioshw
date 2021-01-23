# 大作业：基于CoreML的应用开发

应用：Draw And Draw

## 0.代码行

Calculator:60

GameScene:300

GameState:110

KitManage:350

ShapeFunction:500

Support:300

TouchLogic:260

其他杂项：约100

共约2000行

## 1.应用介绍
基于SpriteKit游戏框架开发的小游戏

主要目标是使用游戏界面下方不断弹出的小方块进行绘图

绘图主题随机给出

与主题越接近(由CoreML模型进行判断，使用的是hw6中的模型)，所用时间越少，得分越高

## 2.游戏玩法

开始界面：点击help进入帮助界面，点击start开始

帮助界面：点击back返回

游戏界面：
          
          将下方绘画组件滑块拖入中间画板

          在中间画板中，单击已有组件，可以进行移动，旋转，删除操作
          
          点击组件中随机出现的星星 能获得一笔画机会(右下角按钮变红)
          
          单击右下角红按钮，可以在画板内进行一次一笔画，三秒后失效
          
          单击back返回开始界面，单击submit提交绘画
          
结算界面：点击back回到开始界面，点击next继续下一关

## 3.代码实现

### 3.1 SpriteKit

用SpriteKit实现的游戏，主要是在SKScene中完成组件，逻辑的设计与实现

先在主View中加入SKView，再将各种组件加入SKScene，最后将Scene present到skview上

SpriteKit中的组件(场景，标签，图形...)均为SKNode

其中，标签为SKLabelNode，画板中的图形为SKShapeNode，使用Asset中image的图形为SKSpriteNode

每个SKNode都有parent,child,将创建的组件均设为SKScene的child,即可将组件显示出来

### 3.2 场景截图
游戏的核心是将绘制结果提交给模型判断，如何将SKScene中的场景转为UIImage即为重要环节

使用传统的截图方法(用当前view渲染graphiccontext)无法截取SKScene的场景

需要新建一个SKview,将需要截取的组件(SKNode)加入到新建的SKScene，将SKScene presenet到SKView上

最后使用drawHierarchy绘制

具体见GameScene.swift中imageFromCanvas函数

### 3.3 动画

SpriteKit游戏中，可以任意为SKNode增加动画(SKAction)

为SKNode加入一段动画(SKAction数组)之后，SKNode被加入进某parent(一般就是当前scene)后，就会自动开始进行动画

常用动画有moveTo,fadeIn,fadeOut,removeFromParent等，同时也可以将一段代码段包装成SKAction

在游戏中，在最底下不断出现消失的绘画组件就是由SKAction完成

首先，先随机产生绘图组件，使用SKTexture获取Asset中现有的image,生成SKSpriteNode

之后，为SKSpriteNode加入动画：先moveTo从左移到右，然后removeFromParent从场景中移除

最后将Node加入scece即可

在一个timer内，每一秒进行一次如上操作

具体见GameScene.swift中activeDrawKits函数

同时，绘画组件拖动时的“残影”效果也是由SKAction完成

从touch中得到当前拖动位置，在该位置创建SKNode，使用wait,fadeOut,removeFromParent组合动画完成

### 3.4 触摸逻辑

(具体代码见TouchLogic.swift)

可以override多种touch函数，程序中override了touchBegin,touchMove,touchEnd

分别在 开始触摸 拖动 结束触摸 时调用

每一次touch开始，都会生成一个UITouch对象，该对象在touch结束时才被回收，在拖动时，可以从该对象中get到当前位置

由位置，可以向scene请求得到该位置触摸在哪一个Node上，从而进行逻辑判断

在touchBegin时，将touch与node绑定，加入进字典里

touchMove时，根据当前位置，进行残影动画，或者进行一笔画

touchEnd时，从字典中取出touch，根据当前游戏状态，处理游戏逻辑

### 3.5 图形绘制与图形变换

(具体代码见shapeFunction.swift)

图形绘制主要使用SKShapeNode，其可以通过CGPath或CGRect等创建

主要使用UIBezierPath，创建本泽尔曲线，使用moveTo,addLine,addCurve等函数绘制线段，曲线

将绘制好的本泽尔曲线化为cgpath,创建SKShapeNode

由于SKShapeNode可以直接进行move，移动函数相对简单

而SKShapeNode的zRotation函数始终围绕(0,0)进行旋转，无法满足要求(围绕中心点旋转)

所以，需要自行计算旋转中心，旋转后点坐标，然后重新绘制图形，覆盖原图形

计算部分见Calculator.swift

### 3.6 CoreML

绘图完成后，将结果传入hw6的coreml模型，得到对应的评分结果，直接显示即可

## 4.BUG、心得

●未对画框边界进行判定，移动图形后可能会飘出边界，产生奇怪的结果

●按钮较小，未在实机上操作过，只在xcode simulator上实验游玩过，可能实机上难以按到按钮...

●未处理横屏，程序仅允许竖屏

●SpriteKit框架对动画，触摸，组件等包装较为合理，易于理解，上手较为轻松，同时还提供了GameState的已包装好的状态机，可以方便控制游戏流程，只是没有用上，还是用的传统写法...
