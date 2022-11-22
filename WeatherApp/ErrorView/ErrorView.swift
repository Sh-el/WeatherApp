import SwiftUI

struct ErrorView: View {
    let error: Error
    let color: Color
    
    var body: some View {
        switch error {
        case API.RequestError.invalidRequest:
            InvalidRequest(color: color)
        case API.RequestError.decodingError:
            DecodingError()
        default:
            ErrorOther(color: color)
        }
    }
}


