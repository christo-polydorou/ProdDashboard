import SwiftUI

struct SettingsView: View {
    @AppStorage("machineLearningEnabled") private var machineLearningEnabled = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: 0xF9E7C4).ignoresSafeArea()

                Form {
                    Section(header: Text("General Settings")) {
                        Toggle("Machine Learning Suggestions", isOn: $machineLearningEnabled)
                    }
                    
                    Section(header: Text("Appearance")) {
                        Toggle("Dark Mode", isOn: Binding(
                            get: { colorScheme == .dark },
                            set: { _ in
                                if colorScheme == .dark {
                                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                                } else {
                                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
