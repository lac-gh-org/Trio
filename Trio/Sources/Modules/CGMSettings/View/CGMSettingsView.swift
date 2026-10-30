import LoopKit
import LoopKitUI
import SwiftUI
import UIKit

extension CGMSettings {
    struct CGMSettingsView: UIViewControllerRepresentable {
        let cgmManager: CGMManagerUI?
        let bluetoothManager: BluetoothStateManager
        let unit: GlucoseUnits
        weak var completionDelegate: CompletionDelegate?

        func makeUIViewController(context _: UIViewControllerRepresentableContext<CGMSettingsView>) -> UIViewController {
            let displayGlucosePreference: DisplayGlucosePreference
            switch unit {
            case .mgdL:
                displayGlucosePreference = DisplayGlucosePreference(displayGlucoseUnit: .milligramsPerDeciliter)
            case .mmolL:
                displayGlucosePreference = DisplayGlucosePreference(displayGlucoseUnit: .millimolesPerLiter)
            }

            guard let cgmManager = cgmManager else { return UIViewController() }

            var vc = cgmManager.settingsViewController(
                bluetoothProvider: bluetoothManager,
                displayGlucosePreference: displayGlucosePreference,
                colorPalette: .default,
                allowDebugFeatures: false
            )
            // vc.cgmManagerOnboardingDelegate =
            // vc.completionDelegate = self
            vc.completionDelegate = completionDelegate

            return vc
        }

        func updateUIViewController(
            _ uiViewController: UIViewController,
            context _: UIViewControllerRepresentableContext<CGMSettingsView>
        ) {
            uiViewController.isModalInPresentation = true
        }
    }
}

struct CGMManagerSettingsDestination: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var state: CGMSettings.StateModel
    let cgmManager: CGMManagerUI

    var body: some View {
        CGMSettings.CGMSettingsView(
            cgmManager: cgmManager,
            bluetoothManager: state.provider.apsManager.bluetoothManager!,
            unit: state.settingsManager.settings.units,
            completionDelegate: state
        )
        .onAppear {
            state.dismissManagerSettings = { dismiss() }
        }
        .onDisappear {
            state.dismissManagerSettings = nil
        }
    }
}
