//
//  PhotoCaptureView.swift
//  realtime_crowd_insights
//
//  Created by Mauricio Garza on 9/29/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Binding var showImagePicker: Bool
    @Binding var image: Image?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider{
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")))
    }
}
