#
#  AppDelegate.rb
#  YourFace
#
#  Created by Haris Amin on 6/18/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#

class AppDelegate
    attr_accessor :window, :camera_preview
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
        @detector = CIDetector.detectorOfType "CIDetectorTypeFace", context:nil, options: {CIDetectorAccuracy: CIDetectorAccuracyLow}
        
        session = AVCaptureSession.new
        device = AVCaptureDevice.defaultDeviceWithMediaType AVMediaTypeVideo
        
        session.sessionPreset = AVCaptureSessionPreset640x480
        width = 640
        height = 480
        
        input = AVCaptureDeviceInput.deviceInputWithDevice device, error:nil
        output = AVCaptureVideoDataOutput.new
        output.alwaysDiscardsLateVideoFrames = true
        
        queue = Dispatch::Queue.new('cameraQueue')
        output.setSampleBufferDelegate self, queue:queue.dispatch_object
        
        #output.setVideoSettings KCVPixelBufferPixelFormatTypeKey => KCVPixelFormatType_32BGRA, KCVPixelBufferWidthKey => width, KCVPixelBufferHeightKey => height
        
        session.addInput input
        session.addOutput output
        
        @preview_layer = AVCaptureVideoPreviewLayer.layerWithSession session
        @preview_layer.frame = [0.0, 0.0, width, height]
        @preview_layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        @preview_layer.affineTransform = CGAffineTransformMakeScale -1,1
        
        session.startRunning
        
        #window.setFrame [0.0, 0.0, width, height], display:true, animate:true
        window.center
        window.delegate = self
        
        #window.contentView.wantsLayer = true
        #window.contentView.layer.addSublayer @preview_layer
        
        #window.orderFrontRegardless
        
        camera_preview.wantsLayer = true
        camera_preview.layer.addSublayer @preview_layer
    end
    
    def captureOutput(captureOutput, didOutputSampleBuffer:sampleBuffer, fromConnection:connection)
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        image = CIImage.imageWithCVImageBuffer(imageBuffer)
        
        features = @detector.featuresInImage(image)
        
        features.each do |feature|
            NSLog "Feature left - #{feature.leftEyePosition}"
        end
        
        nil
    end    
end

