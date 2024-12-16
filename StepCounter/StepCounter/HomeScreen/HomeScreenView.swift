import SwiftUI
import Steps

struct HomeScreenView: View {

    @ObservedObject var viewModel: HomeScreenViewModel

    private let colors = ["Blue", "Green", "Red", "Orange", "Purple"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Customize Your Goal")
                    .font(.title)
                    .fontWeight(.bold)

                ringColor
                .padding()

                stepsInput
                .padding()


                selectedInfo
                .font(.body)
                .foregroundColor(.gray)

            }
            .padding()
            .onChange(of: viewModel.selectedColor) {
                viewModel.setColor()
            }
//            .onChange(of: viewModel.dailyStepGoal) {
//                viewModel.setDailySteps()
//            }

            RingView(viewModel: viewModel)
        }
    }

    private var ringColor: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Choose Ring Color")
                .font(.headline)
            Picker("Select a color", selection: $viewModel.selectedColor) {
                ForEach(colors, id: \.self) { color in
                    Text(color).tag(color)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var stepsInput: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Enter Daily Steps")
                .font(.headline)
            TextField("Steps", value: $viewModel.dailyStepGoal, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.numberPad)
        }
    }

    private var selectedInfo: some View {
        VStack(spacing: 10) {
            Text("Selected Color: \(viewModel.selectedColor)")
            Text(String(format: "Daily Steps Goal: %.0f", viewModel.dailyStepGoal))
        }
    }

}

#Preview {
    HomeScreenView(
        viewModel: HomeScreenViewModel(
            getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
            setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
            getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
            setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository())))
}
