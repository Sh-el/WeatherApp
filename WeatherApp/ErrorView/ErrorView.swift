import SwiftUI

struct ErrorView: View {
    var error: Error
    
    var body: some View {
        switch error {
        case API.RequestError.invalidRequest:
            InvalidRequest()
        case API.RequestError.decodingError:
            DecodingError()
        default:
            ErrorOther()
        }
    }
}


