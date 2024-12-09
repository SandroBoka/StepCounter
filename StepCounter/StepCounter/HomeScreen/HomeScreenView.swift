import SwiftUI

struct HomeScreenView: View {

    @State private var dailySteps = 2000

    var body: some View {
        ScrollView {
            VStack {
                Text("HomeScreenView")
            }
        }
    }

}

#Preview {
    HomeScreenView()
}
