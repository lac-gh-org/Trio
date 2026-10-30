import LoopKitUI
import SwiftUI
import UIKit

extension PumpConfig {
    struct PumpSettingsView: UIViewControllerRepresentable {
        let pumpManager: PumpManagerUI
        let bluetoothManager: BluetoothStateManager
        weak var completionDelegate: CompletionDelegate?
        weak var setupDelegate: PumpManagerOnboardingDelegate?

        func makeUIViewController(context _: UIViewControllerRepresentableContext<PumpSettingsView>) -> UIViewController {
            var vc = pumpManager.settingsViewController(
                bluetoothProvider: bluetoothManager,
                pumpManagerOnboardingDelegate: setupDelegate
            )
            vc.completionDelegate = completionDelegate
            return vc
        }

        func updateUIViewController(_: UIViewController, context _: UIViewControllerRepresentableContext<PumpSettingsView>) {}
    }
}

struct PumpManagerSettingsDestination: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var state: PumpConfig.StateModel
    let pumpManager: PumpManagerUI

    var body: some View {
        PumpConfig.PumpSettingsView(
            pumpManager: pumpManager,
            bluetoothManager: state.provider.apsManager.bluetoothManager!,
            completionDelegate: state,
            setupDelegate: state
        )
        .onAppear {
            state.dismissManagerSettings = { dismiss() }
        }
        .onDisappear {
            state.dismissManagerSettings = nil
        }
    }
}
