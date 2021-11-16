import SwiftUI

enum Kind: String, CaseIterable, Equatable {
    case activeDryYeast = "Active Dry"
    case instantYeast = "Instant"
    case freshYeast = "Fresh"
}

struct ContentView: View {
    enum Field: Hashable {
        case from
    }

    @State private var from: String = ""
    @State private var fromKind: Kind = .activeDryYeast
    @State private var toKind: Kind = .freshYeast
    @FocusState private var focused: Bool

    private var fromValue: Double { Double(from) ?? 0 }

    // From https://foodgeek.dk/da/fra_us_active_dry_yeast_til_dk_frisk_gaer/
    private var toValue: Double {
        switch (fromKind, toKind) {
        case (.activeDryYeast, .freshYeast):
            return fromValue * 4.23
        case (.activeDryYeast, .instantYeast):
            return fromValue * 0.8
        case (.activeDryYeast, .activeDryYeast):
            return fromValue * 1.0

        case (.instantYeast, .freshYeast):
            return fromValue * 5.29
        case (.instantYeast, .activeDryYeast):
            return fromValue * 1.25
        case (.instantYeast, .instantYeast):
            return fromValue * 1.0

        case (.freshYeast, .activeDryYeast):
            return fromValue * 0.23
        case (.freshYeast, .instantYeast):
            return fromValue * 0.18
        case (.freshYeast, .freshYeast):
            return fromValue * 1.0
        }
    }

    private var to: String {
        if toValue.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(toValue))"
        } else {
            return String(format: "%.2f", toValue)
        }
    }

    init() {
        UISegmentedControl.appearance()
            .setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: 17)], for: .normal
            )
    }

    var body: some View {
        VStack {
            HStack {
                Text("From")
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(width: 60)
                Picker("", selection: $fromKind) {
                    ForEach(Kind.allCases, id: \.rawValue) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }.pickerStyle(.segmented)
            }
            HStack {
                Text("To")
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(width: 60)
                Picker("", selection: $toKind) {
                    ForEach(Kind.allCases, id: \.rawValue) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }.pickerStyle(.segmented)
            }
            HStack {
                VStack {
                    Text(" ")
                    HStack(alignment: .bottom) {
                        Text("From").bold()
                        Spacer()
                        TextField("0", text: $from)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused($focused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    focused = true
                                }
                            }
                        Text("g").foregroundColor(.secondary)
                    }
                    HStack(alignment: .bottom) {
                        Text("To").bold()
                        Spacer()
                        Text(to).multilineTextAlignment(.trailing)
                        Text("g").foregroundColor(.secondary)
                    }
                }
                .frame(width: 200)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
