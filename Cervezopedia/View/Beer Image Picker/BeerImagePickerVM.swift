//
//  BeerImagePickerVM.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

final class BeerImagePickerVM: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            guard let imageSelection else { return }
            Task {
                if let data = try? await imageSelection.loadTransferable(type: Data.self) {
                    if let beerImage = UIImage(data: data) {
                        DispatchQueue.main.async { BeerImageManager.shared.save(beerImage: beerImage, withName: UUID().uuidString)
                        }
                    }
                }
            }
        }
    }
}
