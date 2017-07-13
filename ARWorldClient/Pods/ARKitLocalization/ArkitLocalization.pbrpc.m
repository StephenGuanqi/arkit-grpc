#import "ArkitLocalization.pbrpc.h"

#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

@implementation ARLARKitLocalization

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  return (self = [super initWithHost:host packageName:@"arkitlocalization" serviceName:@"ARKitLocalization"]);
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}


#pragma mark GetARWorld2WorldTransform(ARInfo) returns (ARWorld2World)

- (void)getARWorld2WorldTransformWithRequest:(ARLARInfo *)request handler:(void(^)(ARLARWorld2World *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetARWorld2WorldTransformWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetARWorld2WorldTransformWithRequest:(ARLARInfo *)request handler:(void(^)(ARLARWorld2World *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetARWorld2WorldTransform"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[ARLARWorld2World class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark TestImageInterface(ARKitImage) returns (ServerResponse)

- (void)testImageInterfaceWithRequest:(ARLARKitImage *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToTestImageInterfaceWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToTestImageInterfaceWithRequest:(ARLARKitImage *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"TestImageInterface"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[ARLServerResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark TestTransformInterface(ARKitCameraPos) returns (ServerResponse)

- (void)testTransformInterfaceWithRequest:(ARLARKitCameraPos *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToTestTransformInterfaceWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToTestTransformInterfaceWithRequest:(ARLARKitCameraPos *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"TestTransformInterface"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[ARLServerResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
@end
