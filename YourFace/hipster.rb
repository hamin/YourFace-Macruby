#
#  hipster.rb
#  YourFace
#
#  Created by Haris Amin on 6/22/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#

class Hipster
    t_url = NSURL.URLWithString("http://dl.dropbox.com/u/349788/mustache.png")
    t_source = CGImageSourceCreateWithURL t_url, nil
    @@tache = CGImageSourceCreateImageAtIndex t_source, 0, nil
    
    g_url = NSURL.URLWithString("http://dl.dropbox.com/u/349788/glasses.png")
    g_source = CGImageSourceCreateWithURL g_url, nil
    @@glasses = CGImageSourceCreateImageAtIndex g_source, 0, nil
    
    h_url = NSURL.URLWithString("http://i.imgur.com/6NiWG.png")
    h_source = CGImageSourceCreateWithURL h_url, nil
    @@hat = CGImageSourceCreateImageAtIndex h_source, 0, nil
    
    def initialize(layer)
        @bounds = CGRectZero 
        Dispatch::Queue.main.async do
            @face_layer = layer
            add_feature_layer(:@tache, @@tache)
            add_feature_layer(:@glasses, @@glasses)
            add_feature_layer(:@hat, @@hat)
        end
    end
    
    def add_feature_layer(instance_var_name, image)
        layer = instance_variable_set instance_var_name, CALayer.layer
        layer.contents = image
        layer.contentsGravity = KCAGravityResize
        @face_layer.addSublayer layer
    end
    
    def feature_intersection_size(feature)
        r = CGRectIntersection(feature.bounds, @bounds)
        r.size.width * r.size.height
    end
    
    def hide_features
        Dispatch::Queue.main.async do
            [@tache, @hat, @glasses].each { |e| e.opacity = 0 }
        end
    end
    
    def rearrange_features(feature)
        Dispatch::Queue.main.async do
            @bounds = feature.bounds
            if feature.hasRightEyePosition && feature.hasLeftEyePosition && feature.hasMouthPosition
                w = feature.bounds.size.width
                h = feature.bounds.size.height/5
                
                @tache.opacity = 0.9
                @tache.bounds = [0, 0, w, h]
                @tache.position = [(feature.mouthPosition.x + (feature.leftEyePosition.x + feature.rightEyePosition.x)/2)/2, feature.mouthPosition.y+ h/2]
                rotation = Math.atan2(feature.rightEyePosition.y-feature.leftEyePosition.y,feature.rightEyePosition.x-feature.leftEyePosition.x)
                @tache.setValue rotation, forKeyPath: "transform.rotation"
                
                w = feature.bounds.size.width
                h = feature.bounds.size.height/2.5
                
                @glasses.opacity = 1.0
                @glasses.bounds = [0, 0, w, h]
                @glasses.position = [(feature.leftEyePosition.x+feature.rightEyePosition.x)/2, (feature.rightEyePosition.y + feature.leftEyePosition.y)/2]
                rotation = Math.atan2(feature.rightEyePosition.y-feature.leftEyePosition.y,feature.rightEyePosition.x-feature.leftEyePosition.x)
                @glasses.setValue rotation, forKeyPath: "transform.rotation"
                
                w = feature.bounds.size.width*5/4
                h = feature.bounds.size.height*5/4
                
                @hat.opacity = 1.0
                @hat.bounds = [0, 0, w, h]
                #@hat.position = [(feature.rightEyePosition.x + feature.leftEyePosition.x + feature.mouthPosition.x)/3, (feature.leftEyePosition.y+feature.rightEyePosition.y)/2- h/7 +h/2]
                #rotation = 25*Math::PI/180+Math.atan2(feature.rightEyePosition.y-feature.leftEyePosition.y,feature.rightEyePosition.x-feature.leftEyePosition.x)
                
                @hat.position = [(feature.leftEyePosition.x+feature.rightEyePosition.x)/2, (feature.rightEyePosition.y + feature.leftEyePosition.y)]
                rotation = Math.atan2(feature.rightEyePosition.y-feature.leftEyePosition.y,feature.rightEyePosition.x-feature.leftEyePosition.x)
                @hat.setValue rotation, forKeyPath: "transform.rotation"
            end
        end
    end
    
end