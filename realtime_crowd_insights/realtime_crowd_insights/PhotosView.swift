//
//  PhotosView.swift
//  realtime_crowd_insights
//
//  Created by Lorraine Bichara Assad on 9/27/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

import SwiftUI

struct PhotosView: View {
    @State var image: UIImage? = nil
    var body: some View {
        ImagePickerViewController(image: $image)
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
