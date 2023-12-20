//
//  LogoPickerVM.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 19/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

final class LogoPickerVM: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            guard let imageSelection else { return }
            Task {
                if let data = try? await imageSelection.loadTransferable(type: Data.self) {
                    if let uiimage = UIImage(data: data) {
                            DispatchQueue.main.async {LogoManager.shared.saveLogo(whitName: UUID().uuidString, andLogo: uiimage)
                        }
                    }
                }
            }
        }
    }
}
