//
//  BeerImagePicker.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import SwiftUI
import PhotosUI

struct BeerImagePicker: View {
    @Binding var isPresented: Bool
    @Binding var pickedBeerImageName: String
    
    @State var selectedBeerImageName: String = "" {
        didSet {
            if selectedBeerImageName == oldValue {
                selectedBeerImageName = ""
            }
        }
    }
    
    @StateObject private var cache = BeerImageManager.shared.beerImageCache
    @StateObject var viewModel = BeerImagePickerVM()
    
    @State private var isShowingError = false
    @State private var isShowingDeleteAllAlert = false
    
    var body: some View {
        Text("Elegir imagen de cerveza")
            .font(.title)
            .padding()
        Form {
            Section(header: Text("Imágenes de cerveza disponibles")) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    ForEach(cache.entries, id:\.self) { beerImageCacheEntry in
                        Image(uiImage: BeerImageManager.shared.getBeerImage(withName: beerImageCacheEntry.name))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .overlay(selectedBeerImageName == beerImageCacheEntry.name ? Color.blue.opacity(0.5) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                selectedBeerImageName = beerImageCacheEntry.name
                            }
                    }
                }
                
                Button {
                    guard !selectedBeerImageName.isEmpty else {
                        isShowingError = true
                        return
                    }
                    BeerImageManager.shared.removeBeerImage(withName: selectedBeerImageName)
                    selectedBeerImageName = ""
                } label: {
                    Label("Eliminar imagen de cerveza seleccionada", systemImage: "trash")
                }
                .tint(.red)
                
                Button {
                    isShowingDeleteAllAlert = true
                } label: {
                    Label("Eliminar todas las imágenes de cerveza", systemImage: "trash.fill")
                }
                .tint(.red)
                .alert(isPresented: $isShowingDeleteAllAlert) {
                    Alert(title: Text("¿Eliminar todas las imágenes de cerveza?"), message: Text("Esta acción eliminará todas las imágenes de cerveza. ¿Estás seguro?"), primaryButton: .destructive(Text("Eliminar todos")) {
                        BeerImageManager.shared.clearBeerImages()
                    }, secondaryButton: .cancel())
                }
                
                PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                    Text("Abrir galería para agregar imagen de cerveza")
                }
            }
            
            Section {
                Button("Elegir imagen de cerveza \(selectedBeerImageName.isEmpty ? "por defecto" : "seleccionada")") {
                    selectBeerImage()
                }
            }
        }
        .alert(isPresented: $isShowingError) {
            Alert(title: Text("Error al eliminar imagen de cerveza"), message: Text("No se puede eliminar una imagen de cerveza sin elegirla"), dismissButton: .default(Text("Ok")))
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
    
    private func selectBeerImage() {
        pickedBeerImageName = selectedBeerImageName
        isPresented = false
    }
}
