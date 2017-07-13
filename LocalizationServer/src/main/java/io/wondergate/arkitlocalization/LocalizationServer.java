package io.wondergate.arkitlocalization;

import com.google.protobuf.ByteString;
import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.stub.StreamObserver;
import io.wondergate.code.arkitlocalization.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Created by guanqiyu on 11/7/17.
 */
public class LocalizationServer {
    private static final Logger logger = Logger.getLogger(LocalizationServer.class.getName());

    private Server server;
    private final int port;

    public LocalizationServer(int port) {
        this.port = port;
        server = ServerBuilder.forPort(this.port).addService(new ARKitLocalizationService()).build();
    }

    private void start() throws IOException {
        server.start();
        info("Server started, listening on " + port);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.err.println("*** shutting down gRPC server since JVM is shutting down");
            LocalizationServer.this.stop();
            System.err.println("*** server shut down");
        }));
    }

    public void stop() {
        if (server != null) {
            server.shutdown();
        }
    }

    private void blockUntilShutdown() throws InterruptedException {
        server.awaitTermination();
    }

    private static void info(String msg, Object... params) {
        logger.log(Level.INFO, msg, params);
    }

    private static void warn(String msg, Object... params) {
        logger.log(Level.WARNING, msg, params);
    }

    public static void main(String[] args) throws Exception {
        LocalizationServer server = new LocalizationServer(50020);
        server.start();
        server.blockUntilShutdown();
    }

    private static class ARKitLocalizationService extends ARKitLocalizationGrpc.ARKitLocalizationImplBase {

        private File resourceDir;

        public ARKitLocalizationService() {
            resourceDir = new File("src/main/resources");
        }

        /**
         *
         * @param request
         * @param responseObserver
         */
        @Override
        public void getARWorld2WorldTransform(ARInfo request, StreamObserver<ARWorld2World> responseObserver) {
            super.getARWorld2WorldTransform(request, responseObserver);
        }

        /**
         * Test if the ARKitImage has been received by the grpc server. If succeed, return success response.
         *
         * @param request
         * @param responseObserver
         */
        @Override
        public void testImageInterface(ARKitImage request, StreamObserver<ServerResponse> responseObserver) {
            double timestamp = request.getTimestamp();
            info("get timestamp {0}", timestamp);

            byte[] imageBytes = request.getPixeBuffer().toByteArray();
            try {
                BufferedImage arkitImage = ImageIO.read(new ByteArrayInputStream(imageBytes));
                ImageIO.write(arkitImage, "png", new File(resourceDir, timestamp+".png"));
                info("finish writing image for timestamp: {0}", timestamp);
                responseObserver.onNext(ServerResponse.newBuilder().setSucceed(1).build());
            } catch (IOException e) {
                e.printStackTrace();
                warn("error in writing image for timestamp: {0}", timestamp);
                responseObserver.onNext(ServerResponse.newBuilder().setSucceed(0).build());
            } finally {
                responseObserver.onCompleted();
            }
        }

        /**
         * Test if the ARKitCameraPos has been received by the grpc server. If succeed, return success response.
         * @param request
         * @param responseObserver
         */
        @Override
        public void testTransformInterface(ARKitCameraPos request, StreamObserver<ServerResponse> responseObserver) {
            float elementsCount = request.getMCount();
            if (elementsCount != 16) {
                warn("passed camera transform not enough elements");
                responseObserver.onNext(ServerResponse.newBuilder().setSucceed(0).build());
            } else {
                info("get camera pos:");
                List<Float> mList = request.getMList();
                float[][] transform = new float[4][4];
                for (int i = 0; i < 4; i++) {
                    for (int j = 0; j < 4; j++) {
                        transform[i][j] = mList.get(i*4+j);
                        System.out.print(transform[i][j] + " ");
                    }
                    System.out.println();
                }
                responseObserver.onNext(ServerResponse.newBuilder().setSucceed(1).build());
            }
            responseObserver.onCompleted();
        }
    }

}
