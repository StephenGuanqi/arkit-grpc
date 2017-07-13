//
//  ViewController.m
//  ARWorldClient
//
//  Created by Guanqi Yu on 10/7/17.
//  Copyright © 2017 wondergate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate, ARSessionDelegate>
{
    ARFrameHandler* arFrameHandler;
    ARLARKitLocalization *_service;
}

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

static NSString * const kHostAddress = @"192.168.1.131:50020";
    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    self.sceneView.session.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
    
    //other scenceView configuration
    self.sceneView.preferredFramesPerSecond = 30;
    self.sceneView.automaticallyUpdatesLighting = false;
    
    // Create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    
    // Set the scene to the view
    self.sceneView.scene = scene;
    
    
    arFrameHandler = [[ARFrameHandler alloc] init];
    
    [GRPCCall useInsecureConnectionsForHost:kHostAddress];
    _service = [[ARLARKitLocalization alloc] initWithHost:kHostAddress];
    NSLog(@"view did load finished");
    
}

- (IBAction)uiButtonTouched:(id)sender {

    ARFrame *frame = _sceneView.session.currentFrame;
    [self execPosTestRequest:frame];
    [self execImageTestRequest:frame];

}


- (void)execRequest:(ARFrame *) arFrame {
    
}

- (void) execImageTestRequest:(ARFrame*)arFrame {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // Create ARKitImage protobuf message
        NSData* capturedImageData = [arFrameHandler pixelBufferToNSData:arFrame.capturedImage];
        double timestamp = arFrame.timestamp;
        ARLARKitImage *arkitImage = [ARLARKitImage message];
        [arkitImage setTimestamp:timestamp];
        [arkitImage setPixeBuffer:capturedImageData];
        
        [_service testImageInterfaceWithRequest:arkitImage handler:^(ARLServerResponse * _Nullable response, NSError * _Nullable error) {
            if (response) {
                NSLog(@"finish image sent request, status: %d", response.succeed);
            } else if (error) {
                NSLog(@"RPC error: %@", error);
            }
        }];
    });
}

- (void) execPosTestRequest:(ARFrame*)arFrame {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // Create ARKitCameraPos protobuf message
        ARLARKitCameraPos *arkitCameraPos = [ARLARKitCameraPos message];
        GPBFloatArray* transformArray = arkitCameraPos.mArray;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                [transformArray addValue:arFrame.camera.transform.columns[j][i]];
            }
        }
        void (^handler)(ARLServerResponse *responese, NSError *error) = ^(ARLServerResponse * _Nullable response, NSError * _Nullable error) {
            if (response) {
                NSLog(@"finish camera pos sent request, status: %d", response.succeed);
            } else if (error) {
                NSLog(@"RPC error: %@", error);
            }
        };
        [_service testTransformInterfaceWithRequest:arkitCameraPos handler:handler];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    
    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    if (_recordButton.state & UIControlStateHighlighted) {
//        [self execImageTestRequest:frame];
    }
    
}

@end
