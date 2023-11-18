//
//  PrimaryButtonStyle.swift
//  Socialcademy
//
//  Created by Roman on 19.11.2022.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(10)
        .animation(.default, value: isEnabled)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
