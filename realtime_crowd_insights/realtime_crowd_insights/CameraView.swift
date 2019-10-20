//
//  CameraView.swift
//  realtime_crowd_insights
//
//  Created by Lorraine Bichara Assad on 10/18/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    @State var image: UIImage? = nil
    @State var imageSourceType: String? = "camera"

    var body: some View {
        ImageViewController(image: $image, imageSourceType: $imageSourceType)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
