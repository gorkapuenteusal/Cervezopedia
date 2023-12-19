//
//  ImagePicker.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI
import PhotosUI

struct LogoPicker: View { // TODO: - Añadir un isLoading para poner de pega
    @Binding var selectedLogoName: String
    @StateObject private var cache = LogoManager.shared.logoCache
    @StateObject var viewModel = LogoPickerVM()
    
    var body: some View {
        VStack {
            Text("Seleccionar logo").font(.title2).foregroundColor(.accentColor)
            Form {
                Section(header: Text("Imagen seleccionada")) {
                    Image(uiImage: LogoManager.shared.getLogo(withName: selectedLogoName))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                
                Section(header: Text("Logos disponibles")) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                        ForEach(cache.getAllEntries(), id:\.self) { imageWithName in
                            Image(uiImage: LogoManager.shared.getLogo(withName: imageWithName.name))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            .overlay(
                                selectedLogoName == imageWithName.name ? Color.blue.opacity(0.5) : Color.clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                selectedLogoName = imageWithName.name
                            }
                            .onLongPressGesture {
                                LogoManager.shared.removeLogo(withName: imageWithName.name)
                                if selectedLogoName == imageWithName.name {
                                    selectedLogoName = ""
                                }
                            }
                        }
                    }
                    Button {
                        LogoManager.shared.clearLogos()
                    } label: {
                        Label("Eliminar todos los logos", systemImage: "trash.fill")
                    }.tint(.red)
                }
                
                Section(header: Text("Agregar logos")) {
                    PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                        Text("Abrir galería")
                    }
                }
            }
        }
        .padding(.top)
    }
}
