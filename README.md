# arkit-grpc
arkit client app with java server, communicate in grpc.

## Build

For iOS client App:

cd into the ARWorldClient folder, and open the project using xcode. Build it and run on your iphone (with minumum version 6s and iOS version 11.0).

For server:

cd into the Localization Server folder, run `gradle build install` , then start scripts will be generated in the build/install/modelname/bin folder, and all of the java source will be packed in a jar file, plus all of the dependencies like prorobuf and grpc runtime will be placed in the build/install/modelname/lib folder

run start scripts to run the server.

## Usage

Each time you clicked the button on your iphone, the pos of the camera will be sent to the server and printed to the server console, meanwhile the captured the CVPixelBuffer will be compressed to png and send to the server's src/main/resources folder.
