#import "ArkitLocalization.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>



NS_ASSUME_NONNULL_BEGIN

@protocol ARLARKitLocalization <NSObject>

#pragma mark GetARWorld2WorldTransform(ARInfo) returns (ARWorld2World)

- (void)getARWorld2WorldTransformWithRequest:(ARLARInfo *)request handler:(void(^)(ARLARWorld2World *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetARWorld2WorldTransformWithRequest:(ARLARInfo *)request handler:(void(^)(ARLARWorld2World *_Nullable response, NSError *_Nullable error))handler;


#pragma mark TestImageInterface(ARKitImage) returns (ServerResponse)

- (void)testImageInterfaceWithRequest:(ARLARKitImage *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToTestImageInterfaceWithRequest:(ARLARKitImage *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark TestTransformInterface(ARKitCameraPos) returns (ServerResponse)

- (void)testTransformInterfaceWithRequest:(ARLARKitCameraPos *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToTestTransformInterfaceWithRequest:(ARLARKitCameraPos *)request handler:(void(^)(ARLServerResponse *_Nullable response, NSError *_Nullable error))handler;


@end

/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface ARLARKitLocalization : GRPCProtoService<ARLARKitLocalization>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end

NS_ASSUME_NONNULL_END
