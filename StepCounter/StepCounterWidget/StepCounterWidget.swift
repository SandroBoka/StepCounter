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
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(spacing: 0) {
            if widgetFamily == .systemSmall {
                smallWidget
            } else if widgetFamily == .systemMedium {
                mediumWidget
            }
        }
        .foregroundStyle(.primaryForeground)
        .containerBackground(.widgetGray.gradient, for: .widget)
    }

    private var smallWidget: some View {
        VStack {
            Text("Steps")
                .fontWeight(.semibold)

            WidgetRingView(isSmall: true, viewModel: entry.viewModel)

            Text("\(Int(entry.viewModel.stepCount)) / \(Int(entry.viewModel.dailyStepGoal))")
                .font(.headline)
        }
    }

    private var mediumWidget: some View {
        HStack {
            WidgetRingView(isSmall: false, viewModel: entry.viewModel)
                .padding(.leading, 10)

            Spacer()

            Divider()
                .padding(.horizontal, 10)

            Spacer()

            VStack(spacing: 12) {
                Text("Steps")
                    .fontWeight(.semibold)

                Text("\(Int(entry.viewModel.stepCount)) / \(Int(entry.viewModel.dailyStepGoal))")
                    .font(.headline)

                Divider()

                Text("Move Goal")
                    .font(.headline)

                Text("\(Int(entry.viewModel.percent)) %")
                    .font(.headline)
            }
            .padding(.trailing, 10)
        }
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
        .supportedFamilies([.systemSmall, .systemMedium])
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
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }

}
