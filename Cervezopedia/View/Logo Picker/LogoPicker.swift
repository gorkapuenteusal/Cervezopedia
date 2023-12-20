//
//  ImagePicker.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI
import PhotosUI

struct LogoPicker: View { // TODO: - Añadir un isLoading para poner de pega, además la imagen solo puede ser .png
    @Binding var isPresented: Bool
    @Binding var pickedLogoName: String
    
    @State var selectedLogoName: String = "" {
        didSet {
            if selectedLogoName == oldValue {
                selectedLogoName = ""
            }
        }
    }
    
    @StateObject private var cache = LogoManager.shared.logoCache
    @StateObject var viewModel = LogoPickerVM()
    
    @State private var isShowingError = false
    @State private var isShowingDeleteAllAlert = false
    
    var body: some View {
        Text("Elegir logo")
            .font(.title)
            .padding()
        Form {
            Section(header: Text("Logos disponibles")) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    ForEach(cache.entries, id:\.self) { logoCacheEntry in
                        Image(uiImage: LogoManager.shared.getLogo(withName: logoCacheEntry.name))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        .overlay(
                            selectedLogoName == logoCacheEntry.name ? Color.blue.opacity(0.5) : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            selectedLogoName = logoCacheEntry.name
                        }
                        .onLongPressGesture {
                            LogoManager.shared.removeLogo(withName: logoCacheEntry.name)
                            if selectedLogoName == logoCacheEntry.name {
                                selectedLogoName = ""
                            }
                        }
                    }
                }
                
                Button {
                    guard !selectedLogoName.isEmpty else {
                        isShowingError = true
                        return
                    }
                    LogoManager.shared.removeLogo(withName: selectedLogoName)
                    selectedLogoName = ""
                } label: {
                    Label("Eliminar logo seleccionado", systemImage: "trash")
                }.tint(.red)
                
                Button {
                    isShowingDeleteAllAlert = true
                } label: {
                    Label("Eliminar todos los logos", systemImage: "trash.fill")
                }.tint(.red)
                .alert(isPresented: $isShowingDeleteAllAlert) {
                    Alert(
                        title: Text("¿Eliminar todos los logos?"),
                        message: Text("Esta acción eliminará todos los logos. ¿Estás seguro?"),
                        primaryButton: .destructive(Text("Eliminar todos")) {
                            LogoManager.shared.clearLogos()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                PhotosPicker(selection: $viewModel.imageSelection, matching: .all(of: [.images, .not(.livePhotos)])) {
                    Text("Abrir galería para agregar logo")
                }
                
                Button("Elegir logo \(selectedLogoName.isEmpty ? "por defecto" : "seleccionado")") {
                    selectLogo()
                }
            }
        }
        .alert(isPresented: $isShowingError) {
            Alert(title: Text("Error al eliminar logo"), message: Text("No se puede eliminar un logo sin elegirlo"), dismissButton: .default(Text("Ok")))
        }
        .overlay(
            VStack {
                Spacer()
                Text("Desliza hacia abajo para cancelar")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        )
    }
    
    private func selectLogo() {
        pickedLogoName = selectedLogoName
        isPresented = false
    }
}
