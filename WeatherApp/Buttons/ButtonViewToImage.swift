//
//  ButtonViewToImage.swift
//  WeatherApp
//
//  Created by Stanislav Shelipov on 13.10.2022.
//

import SwiftUI

struct ButtonViewToImage: View {
    
    var forecastToday: ForecastTodayModel
    @State private var image: UIImage?
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    if let image = ImageRenderer(content: ForecastTodayView(forecastTodayForCity: forecastToday)).uiImage {
                        self.image = image
                    } else {return}
                    
                } label: {
                    Text("View to Image")
                }
                Spacer()
            }
            if image != nil {
                Image(uiImage: image!)
            }
            
            
        }
    }
}

//struct ButtonViewToImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonViewToImage()
//    }
//}
