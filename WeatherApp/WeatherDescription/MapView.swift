//
//  MapView.swift
//  WeatherApp
//
//  Created by Stanislav Shelipov on 12.10.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var mapRegion: MKCoordinateRegion
    var geo: GeometryProxy
    
    var body: some View {
        Map(coordinateRegion: $mapRegion)
            .frame(width: geo.size.width - 10, height: geo.size.width)
            .bordered()
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
