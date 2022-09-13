import SwiftUI

struct ErrorView: View {
    var error: Error
    
    var body: some View {
        switch error {
        case API.RequestError.invalidRequest:
            ErrorInvalidRequestForMainView1()
        default:
            ErrorOtherForMainView1()
        }
    
    }
}


