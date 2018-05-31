//
//  ViewController.m
//  SceneKitDemo
//
//  Created by 刘志伟 on 2018/3/27.
//  Copyright © 2018年 刘志伟. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController (){
    SCNView *scnView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addSCNView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
- (void)addSCNView{
    // 初始化 SCNView
    scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.allowsCameraControl = true;
    scnView.backgroundColor  = [UIColor yellowColor];
    scnView.scene = [SCNScene sceneNamed:@"Model.obj"];
    
    // 添加照相机（眼睛看的视图角度）
    SCNNode *cameranode = [SCNNode node];
    cameranode.camera = [SCNCamera camera];
    cameranode.camera.automaticallyAdjustsZRange = true;
    cameranode.position = SCNVector3Make(0, 0, 100);
    [scnView.scene.rootNode addChildNode:cameranode];
    
    // 添加旋转
    SCNNode *ship = [scnView.scene.rootNode childNodeWithName:@"MDL_OBJ_Model_0" recursively:YES];
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0 z:2 duration:0.8]]];
    
    // 添加渲染
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber10_0) {
        // 经测试这种方式在10.0以下获取不到SCNNode对象
        SCNNode *node = [scnView.scene.rootNode childNodeWithName:@"MDL_OBJ_Model_0" recursively:YES];
        node.geometry.firstMaterial.lightingModelName = SCNLightingModelBlinn;
        node.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"Model_0.jpg"];
        [scnView.scene.rootNode addChildNode:node];
    }
    else {
        [scnView.scene.rootNode childNodesPassingTest:^BOOL(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
            if (child) {
                child.geometry.firstMaterial.lightingModelName = SCNLightingModelBlinn;
                child.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"Model_0.jpg"];
                [scnView.scene.rootNode addChildNode:child];
                return YES;
            }
            else {
                return NO;
            }
        }];
    }
    
    [self.view addSubview:scnView];
}

@end
