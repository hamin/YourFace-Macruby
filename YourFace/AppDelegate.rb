#
#  AppDelegate.rb
#  YourFace
#
#  Created by Haris Amin on 6/18/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#

require 'face'
require 'hipster'

class AppDelegate
    attr_accessor :window, :camera_preview, :picture_output, :recognized_label, :face_key, :face_secret
    
    def applicationDidFinishLaunching(a_notification)
        # For Face.com recognition API call
        @face_key = ""
        @face_secret = ""
        
        @hipsters_array = [] # For some fun :)
        
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
        
        
        # Picture output settings
        @picture_output = AVCaptureStillImageOutput.new
        output_settings = {AVVideoCodecKey => AVVideoCodecJPEG}
        @picture_output.outputSettings = output_settings
        session.addOutput @picture_output
        
        session.addInput input
        session.addOutput output
        
        @preview_layer = AVCaptureVideoPreviewLayer.layerWithSession session
        @preview_layer.frame = [0.0, 0.0, width, height]
        @preview_layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        @preview_layer.affineTransform = CGAffineTransformMakeScale -1,1
        
        session.startRunning
        
        window.center
        window.delegate = self
        
        camera_preview.wantsLayer = true
        camera_preview.layer.addSublayer @preview_layer
    end
    
    def add_face
        @hipsters_array << Hipster.new(@preview_layer)
    end
    
    def captureOutput(captureOutput, didOutputSampleBuffer:sampleBuffer, fromConnection:connection)
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        image = CIImage.imageWithCVImageBuffer(imageBuffer)
        
        features = @detector.featuresInImage(image)
        
        add_face while features.size > @hipsters_array.size
        
        hipsters = @hipsters_array.dup
        features.each do |feature|
            matched_face = hipsters.sort_by! {|s| s.feature_intersection_size(feature) }.pop
            matched_face.rearrange_features feature
        end
        hipsters.each { |e| e.hide_features } # any remaining hipsters have exited the frame and should be hidden.
        
        nil
    end
    
    def takePicture(sender)
        img_connection = @picture_output.connectionWithMediaType AVMediaTypeVideo
        NSLog "IT CAME TO TAKE PICTURE"
        
        call_back = Proc.new do |img_buffer, error|
            NSLog "IT CAME TO CALLBACK"
            image_data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation img_buffer
            filename = "#{Dir.pwd}/test_pic.jpeg"
            image_data.writeToFile(filename, atomically:true)
            
            # You can also write to file the good ol' ruby way if you like :)
            # File.open(filename, 'wb') {|f| f.write(image_data.to_str) }
            
            client = Face.get_client(:api_key => @face_key, :api_secret => @face_secret)
            resp = client.faces_recognize(:uids => ['all@aminharis7'], :file => File.new(filename, 'rb'), :detector => "normal")
            
            if resp["photos"].first["tags"].size == 0 || resp["photos"].first["tags"].first["uids"].size == 0
                NSLog("Face Found!")
                @recognized_label.stringValue = "Sorry...I don't know Your Face :("
            else
                NSLog("NO FACE Found!!!")
                NSLog(resp.description)
                uid = resp["photos"].first["tags"].first["uids"].first["uid"].split('@').first
                pretty_uid = uid.split(/(?=[A-Z])/).join(' ').capitalize #  Making it look pretty (e.g. 'DrNic' -> 'Dr Nic')
                @recognized_label.stringValue =  "Nice Face #{pretty_uid} :)"
            end
            
        end
        
        @picture_output.captureStillImageAsynchronouslyFromConnection img_connection, completionHandler:call_back
    end    
end

