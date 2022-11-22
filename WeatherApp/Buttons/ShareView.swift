//
//  ShareView.swift
//  WeatherApp
//
//  Created by Stanislav Shelipov on 13.10.2022.
//

import SwiftUI

struct ShareView: View {
    let forecastToday: ForecastTodayModel
    
    var body: some View {
            HStack {
                if let image = ImageRenderer(content: ForecastTodayView(forecastTodayForCity: forecastToday).background(.blue.opacity(0.7))).uiImage {
                    Spacer()
                    ShareLink("", item: Image(uiImage: image), preview: SharePreview("", image: Image(uiImage: image)))
                        .font(.title)
                        .foregroundColor(Constants.textColor)
                        .padding(5)
                        .padding(.top, 5)
                }
            }
    }
}

