import WidgetKit
import SwiftUI
import Steps

struct Provider: TimelineProvider {

    private let viewModel = WidgetViewModel(
        getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
        setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
        getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
        setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository()))

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stepCount: 5000, dailyStepGoal: 10000, viewModel: viewModel)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), stepCount: 5000, dailyStepGoal: 10000, viewModel: viewModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, stepCount: 5000, dailyStepGoal: 10000, viewModel: viewModel)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let stepCount: Double
    let dailyStepGoal: Double
    let viewModel: WidgetViewModel
}

struct StepCounterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Steps: \(Int(entry.viewModel.stepCount)) / \(Int(entry.viewModel.dailyStepGoal))")
                .fontWeight(.bold)
                .foregroundStyle(AppColor.color(from: entry.viewModel.selectedColor))
        }
        .containerBackground(for: .widget) {
            Color.widgetGray
        }
        .ignoresSafeArea()
    }
}

@main
struct StepCounterWidget: Widget {
    let kind: String = "StepCounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                StepCounterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                StepCounterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StepCounterWidget_Previews: PreviewProvider {

    private static let viewModel = WidgetViewModel(
        getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
        setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
        getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
        setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository()))

    static var previews: some View {
        StepCounterWidgetEntryView(
            entry: SimpleEntry(date: Date(), stepCount: 5000, dailyStepGoal: 10000, viewModel: viewModel))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }

}
